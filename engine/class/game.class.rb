class Game

  attr_accessor :state, :app_base_path, :path, :config, :player, :characters, :locations, :doors, :props, :turns, :over

  include Handles_YAML_Files
  include Handles_Scoring

  def initialize(config, app_base_path, path = 'game/')

    @config        = config
    @app_base_path = app_base_path
    @path          = path

    @game = self

    # transitions are sets of triggering conditions and resulting outcomes
    @transitions = load_yaml_file("#{path}transitions.yaml")

    restart(false)

  end

  def restart(require_confirmation = true, prompt = "Are you sure you want to restart your game?")

    # if confirmation is required, get user input a pop up dialogue
    restart_confirmed = (require_confirmation == true) ? confirm(prompt) : true

    # zzzz

    if restart_confirmed

      @turns = 0
      @state = {}
      @over  = false

      @output_text = ''

      initialize_scoring(path)

      initialize_locations
      @doors      = initialize_doors
      @props      = initialize_props
      @characters = {}
      @player     = initialize_player
      initialize_characters(@locations, @player, @props)
    end

    restart_confirmed

  end

  def restart_or_exit

    #zzzz

    restart(true, "Would you like to play again?") ? true : exit()

  end

  def elements(name)

    if @doors.has_key?(name)
      return @doors[name]
    end

    if @props.has_key?(name)
      return @props[name]
    end

    if @characters.has_key?(name)
      return @characters[name]
    end

    if @locations.has_key?(name)
      return @locations[name]
    end

  end

  def find_alias(alias_to_find)

    [@doors, @props, @characters].each do |elements|

      if element_alias = find_alias_among(elements, alias_to_find)

        return element_alias
      end
    end

    false

  end

  def find_alias_among(elements, alias_to_find)

    elements.each do |id, element|

      if element.aliases

        element.aliases.each do |element_alias|

          if element_alias == alias_to_find

            return element.id
          end
        end
      end
    end

    false

  end

  def initialize_player

    # player data is stored in YAML as a hash
    player_config_file = "#{path}player/player.yaml"
    player_data = load_yaml_file(player_config_file)

    if player_data

      player = Player.new \
        :props => @props,
        :characters => @characters

      map_hash_to_object_attributes(player, player_data)

    else

      error('No player data found at ' + player_config_file)

    end

  end

  def initialize_characters(locations, player, props)

    recursive_find_of_yaml_file_data("#{@path}characters").each do |character_data|

      # create objects from hash of object hashes
      character_data.each do |id, character_definition|

        character = Character.new :locations => locations, :player => player, :props => props
        @characters[id] = map_hash_to_object_attributes(character, character_definition)

        # set object id, so it can be read
        @characters[id].id = id

      end

    end

  end

  def initialize_locations

    @locations = {}

    location_config_path = "#{@path}locations"

    recursive_find_of_yaml_file_data(location_config_path).each do |location_data|

      # create objects from hash of object hashes
      location_data.each do |id, location_definition|

        location = Location.new(location_config_path)

        @locations[id] = map_hash_to_object_attributes(location, location_definition)

        @locations[id].path = location_config_path

        @locations[id].image_file  = "#{location_config_path}/images/#{id}.jpg"

        # set object id, so it can be read
        @locations[id].id = id

      end
    end

    if @locations.length < 1
      error('No location config files found at ' + location_config_path)
    end

  end

  def initialize_doors

    doors = {}

    # door data is stored in YAML as a hash
    door_config_path = "#{path}doors/doors.yaml"
    door_data = load_yaml_file(door_config_path)

    if door_data
      # create objects from hash of object hashes
      door_data.each do |id, door_definition|
        doors[id] = map_hash_to_object_attributes(Door.new, door_definition)
        doors[id].id = id
      end
    else
      error('No door config files found at ' + door_config_path)
    end

    doors

  end

  def initialize_props

    props = {}

    # prop data is stored in YAML as a hash
    prop_config_path = "#{path}props/props.yaml" 
    prop_data = load_yaml_file(prop_config_path)

    if prop_data
      # create objects from hash of object hashes
      prop_data.each do |id, prop_definition|
        props[id] = map_hash_to_object_attributes(Prop.new, prop_definition)
        props[id].id = id
        if !props[id].traits.has_key?('portable')
          props[id].traits['portable'] = true
        end
        if !props[id].traits.has_key?('visible')
          props[id].traits['visible'] = true
        end
      end
    else
      error('No prop config files found at ' + prop_config_path)
    end

    props

  end

  def map_hash_to_object_attributes(object, hash)

    # use hash key => value to set property object attributes
    hash.each do |attribute, value|
      eval('object.' + attribute.gsub(' ', '_') + ' = value')
    end

    object

  end

  def turn

    output = ''

    @characters.each do |name, character|
      output << character.turn_logic
    end

    @props.each do |name, prop|

      if prop.traits['lit'] && prop.traits['lit'] == true
        if prop.traits['burn_turns'] > 0
          @props[name].traits['burn_turns'] -= 1
        else
          output << "The #{name} has gone out.\n"
          @props[name].traits['lit'] = false
        end
      end

    end

    output << transitions

    @turns += 1

    output

  end

  def save(filename = "#{path}player/saved_game.yaml")

    game_data = {
      'turn'       => @turns,
      'state'      => @state,
      'over'       => @over,

      'player'     => @player,
      'locations'  => @locations,
      'doors'      => @doors,
      'characters' => @characters,
      'props'      => @props
    }

    save_data_as_yaml_file(game_data, filename)

  end

  def load(filename = "#{path}player/saved_game.yaml")

    game_data = load_yaml_file(filename)

    @turn       = game_data['turns']
    @state      = game_data['state']
    @over       = game_data['over']

    @player     = game_data['player']
    @locations  = game_data['locations']
    @doors      = game_data['doors']
    @characters = game_data['characters']
    @props      = game_data['props']

  end

  def prop_404(prop)
    "I don't see a #{prop}.\r"
  end

  def prop_located_at(prop, location)

    @props[prop] && @props[prop].location == location

  end

  def transitions

    output = ''

    if @transitions

      # attempt each transition
      @transitions['conditions'].each do |conditions, outcomes|

        effect_outcome = false

        # check each condition in the transition
        conditions.each do |condition|
          if instance_eval(condition)
            effect_outcome = true
          end
        end

        # if a condition was met, effect all outcomes
        if effect_outcome == true

          outcomes.each do |outcome|

            # evaluate outcome
            result = eval(@transitions['outcomes'][outcome])

            # if outcome can be converted to a string, add to output
            if result.to_s
              output << result.to_s
            end
          end
        end

      end
    end

    output

  end

  def attempt_open_item(item, with_prop)

    output = ''

    item_object = (@props[item]) ? @props[item] : @doors[item]

    if item_object.traits.has_key?('opened')
      if item_object.traits['opened']
        output << "It's already open.\n"
      elsif item_object.traits['opens_with']
        if with_prop
          if prop_located_at(with_prop, 'player') and item_object.traits['opens_with'].index(with_prop)
            output << open(item)
          end
        else
          output << "It won't open. Maybe you need something to open it with?\n"
        end
      else
        return open(item)
      end
    else
      output << "You can't open the #{item}.\n"
    end

    output

  end

  def open(item)

    if @props[item]
      prop_open(item)
    elsif @doors[item]
      door_open(item)
    else
      error("game.open called on item that isn't a prop or door.")
    end
  end

  def door_open(door)

    output = ''

    if @doors[door]

      output << "You open the #{@doors[door].name}.\n"

      @doors[door].traits['opened'] = true

    end

    output

  end

  def prop_open(prop)

    output = ''

    if @props[prop]

      output << "You open #{@props[prop].noun}.\n"

      if @props[prop].traits['contains']

        @props[prop].traits['contains'].each do |contained_item|

          type           = contained_item.keys[0]
          contained_prop = contained_item.values[0]

          # we leave open the possibility of having objects contain characters, etc.
          # ...but maybe we should just have it be any key or any game component?
          if type == 'prop'

            output << "#{@props[prop].noun_cap} contains #{@props[contained_prop].noun_direct}.\n"
            @props[contained_prop].location = @player.location
          end
        end
      end

      @props[prop].traits['opened'] = true

    end

    output

  end

  def event(object, type)

    if object.events && object.events[type]

      event_response = object.events[type]

      begin

        result = instance_eval(event_response)

        return result

      # if evaluation of event response fails, return the response as text
      rescue SyntaxError, NameError

        alert('Error evaluating event response ' + type + ' for ' + object.name)
        return event_response

      end
    end

    # return blank string if no event has happened
    ""

  end

end
