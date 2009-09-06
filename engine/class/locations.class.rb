class Locations

  attr_accessor :id, :path, :loaded, :name, :description, :dark, :exits, :revealed_exit_data, :description_notes, :image_file

  include Handles_YAML_Files

  # is this function needed?
  def initialize(path)

    @path = path

    # exits revealed by player actions get stored here
    @revealed_exit_data = {}

    # additional description details revealed by player actions get stored here
    @description_notes = {}

  end

  #def [](name)

    # don't load the location if it's already been loaded
  #  if @name != name
  #    load(name)
  #  end

  #  self

  #end

  def load(name)

    location_file = "#{@path}/#{name}.yaml"

    location_data = load_yaml_file(location_file)

    if location_data

      @location = location_data[name]

      @name        = @location['name']
      @description = @location['description']
      @dark        = @location['dark']
      @exits       = @location['exits'] ? @location['exits'] : {}
      @image_file  = "#{@path}images/#{@name}.jpg"

      # add any exits revealed by player actions
      if @revealed_exit_data[@name]
        @revealed_exit_data[@name].each do |direction, exit_data|
          @exits[direction] = {'destination' => exit_data['destination']}
        end
      end

    else
      error('Location data not found at ' + "#{@path}#{name}.yaml")
    end

  end

  def has_exit(direction)

    revealed_found = false

    if @revealed_exit_data[@name]
      if @revealed_exit_data[@name][direction]
        revealed_found = true
      end
    end

    if @exits[direction] or revealed_found
      true
    end
  end

  def add_to_description(text)

    @description_notes[@name] ||= ''
    @description_notes[@name] += text

  end

  def opposite_direction(direction)

    opposite = {
      'north' => 'south',
      'south' => 'north',
      'east' => 'west',
      'west' => 'east',
      'up' => 'down',
      'down' => 'up'
    }

    opposite[direction]

  end

  def revealed_exits

    exits = {}

    if (@revealed_exit_data[@name])
      @revealed_exit_data[@name].each do |direction, exit_data|
        exits[direction] = exit_data['destination']
      end
    end

    exits

  end

  def describe(doors, props, characters, light = nil)

    if @dark and light != true

     description = "It is too dark to see.\n"

    else

      # describe current location
      description = @description.dup
      description += @description_notes[@name] if @description_notes[@name]

      description << describe_characters(characters)

      description << describe_revealed_exit_data(props)

      description << describe_doors(doors)

      description << describe_props(props)

    end

    description

  end

  def describe_characters(characters)

    output = ''

    # describe any characters in the location
    characters_seen = []

    characters.each do |character, character_data|
      if characters[character].location == @name
        characters_seen << character
      end
    end

    output << describe_game_components(characters_seen)

    output

  end

  def describe_doors(doors)

    output = ''

    # describe any doors in the location
    doors_seen = []

    doors.each do |door, door_data|
      if doors[door].locations.include?(@name)
        doors_seen << door
      end
    end

    output << describe_game_components(doors_seen)

    output

  end

  def describe_props(props)

    output = ''

    # describe any props in the location
    props_seen = []

    props.each do |prop, prop_data|
      if props[prop].location == @id and props[prop].traits['visible'] == true
        props_seen << prop
      end
    end

    output << describe_game_components(props_seen)

    output

  end

  def describe_game_components(components)

    output = ''

    if components.size > 0
      output << "You see: "
      component_output = ''
      components.each do |prop|
        if component_output != ''
           component_output << ', '
        end
        component_output << prop
      end
      component_output << ".\n"

      output << component_output
    end

    output

  end

  def describe_revealed_exit_data(props)

    description = ''

    if @revealed_exit_data[@name]
      @revealed_exit_data[@name].each do |direction, exit_data|
        if exit_data['prop'] && exit_data['prop'] != ''
          prop = exit_data['prop']
          if props[prop].location == @name
            description << "The #{exit_data['prop']} leads #{direction}.\n"
          else
            description << "An exit leads #{direction}.\n"
          end
        else
          description << "An exit leads #{direction}.\n"
        end
      end
    end

    description

  end

end
