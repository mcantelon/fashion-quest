# I am a walrus!
#
class Game

  attr_accessor :state, :path, :player, :characters, :locations, :doors, :props, :turns, :over

  include Handles_YAML_Files

  # I am a pig!
  #
  def initialize(path = 'game/')

    @path = path

    # transitions are sets of triggering conditions and resulting outcomes
    @transitions = load_yaml_file("#{path}transitions.yaml")

    restart

  end

  def restart

    @turns = 0
    @state = {}
    @over  = false

    @output_text = ''

    @locations  = Locations.new(@path + 'locations/')
    @doors      = initialize_doors
    @props      = initialize_props
    @player     = initialize_player
    @characters = initialize_characters(@locations, @player, @props)

  end

  def initialize_player

    # player data is stored in YAML as a hash
    player_config_file = "#{path}player/player.yaml"
    player_data = load_yaml_file(player_config_file)

    if player_data
      # create object from hash
      Player.new \
        :props => @props,
        :name => player_data['name'],
        :hp => player_data['hp'],
        :strength => player_data['strength'],
        :dead => player_data['dead'],
        :location => player_data['location']
    else
      error('No player data found at ' + player_config_file)
    end

  end

  def initialize_characters(locations, player, props)

    require 'find'

    characters = {}
    character_config_path = "#{@path}characters"

    # load all commands, recursively, contained in command directory
    Find.find(character_config_path) do |character_file|

      if !FileTest.directory?(character_file) and (character_file.index('.yaml') or character_file.index('.yml'))

        # character data is stored in YAML as a hash
        character_data = load_yaml_file(character_file)

        if character_data
          # create objects from hash of object hashes
          character_data.each do |id, character_definition|
            character = Character.new :locations => locations, :player => player, :props => props
            characters[id] = map_hash_to_object_attributes(character, character_definition)
            characters[id].id = id
          end
        end
      end
    end

    if characters.length < 1
      error('No character config files found at ' + character_config_path)
    end

    characters

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
      end
    else
      error('No prop config files found at ' + prop_config_path)
    end

    props

  end

  def map_hash_to_object_attributes(object, hash)

    # use hash key => value to set property object attributes
    hash.each do |attribute,value|
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

      if prop.lit
        if prop.lit == true
          if prop.burn_turns > 0
            @props[name].burn_turns -= 1
          else
            output << "The #{name} has gone out.\n"
            @props[name].lit = false
          end
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

  def save_history(filename = "#{path}player/saved_history.yaml")

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

  def prop_404(prop)
    "I don't see a #{prop}.\r"
  end

  def prop_located_at(prop, location)

    if @props[prop]
      @props[prop].location == location
    end
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

    if @props[item]
      item_object = @props[item]
    elsif
      item_object = @doors[item]
    end

    if defined? item_object.opened
      if item_object.opened
        output << "It's already open.\n"
      elsif item_object.opens_with
        if with_prop
          if prop_located_at(with_prop, 'player') and item_object.opens_with.index(with_prop)
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

      @doors[door].opened = true

    end

    output

  end

  def prop_open(prop)

    output = ''

    if @props[prop]

      output << "You open the #{@props[prop].name}.\n"

      if @props[prop].contains

        @props[prop].contains.each do |type, contained_prop|

          if type == 'prop'

            output << "The #{@props[prop].name} contains a #{@props[contained_prop].name}.\n"
            @props[contained_prop].location = @player.location

          elsif type == 'exit'

            contained_prop.each do |direction,destination|

              # create new exit
              @locations.exits[direction] = destination

              # let location engine know of this new exit for future location loads
              @locations[@player.location].add_exit(@player.location, prop, direction, destination)

            end
          end
        end
      end

      @props[prop].opened = true

    end

    output

  end



  def event(object, type)

    if object.events

      if object.events[type]

        event_response = object.events[type] #[rand(object.events[type].length)]

        begin

          result = instance_eval(event_response)

          return result

        # if evaluation of event response fails, return the response as text
        rescue SyntaxError, NameError

          alert('Error evaluating event response ' + type + ' for ' + object.name)
          return event_response

        end
      end
    end

    # return blank string if no event has happened
    ""

  end

end
