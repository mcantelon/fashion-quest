class Locations

  attr_accessor :path, :loaded, :name, :description, :exits, :revealed_exit_data, :description_notes, :image_file

  include Handles_YAML_Files

  def initialize(path)

    @path = path

    # exits revealed by player actions get stored here
    @revealed_exit_data = {}

    # additional description details revealed by player actions get stored here
    @description_notes = {}

  end

  def [](name)

    # don't load the location if it's already been loaded
    if @name != name
      load(name)
    end

    self

  end

  def load(name)

    location_file = "#{@path}#{name}.yaml"
    location_data = load_yaml_file(location_file)

    if location_data

      @location = location_data

      @name        = @location['name']
      @description = @location['description']
      @exits       = @location['exits'] ? @location['exits'] : {}
      @image_file  = "#{@path}images/#{@name}.jpg"

      # add any exits revealed by player actions
      if @revealed_exit_data[@name]
        @revealed_exit_data[@name].each do |direction, exit_data|
          @exits[direction] = exit_data['destination']
        end
      end
    else
      error('Location data not found at ' + "#{@path}#{name}.yaml")
    end

  end

  # ?
  def add_exit(location, prop, direction, destination)

    @revealed_exit_data[location] ||= {}
    @revealed_exit_data[location][direction] = {'prop' => prop, 'destination' => destination}

    if opposite_direction(direction)
      @revealed_exit_data[destination] ||= {}
      @revealed_exit_data[destination][opposite_direction(direction)] = {'prop' => prop, 'destination' => location}
    end

  end

  def add_to_description(text)

    @description_notes[@name] ||= ''
    @description_notes[@name] += text

  end

  def opposite_direction(direction)

    opposite = {'north' => 'south',
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

  def describe(props, characters)

    # describe current location
    description = @description.dup
    description += @description_notes[@name] if @description_notes[@name]

    # describe any characters in the location
    characters.each do |character, character_data|
      if characters[character].location == @name
        description << ("You see " + characters[character].noun + ".\n")
      end
    end

    description << describe_revealed_exit_data(props)

    # describe any props in the location (or doors that lead to the location)
    props.each do |prop, prop_data|
      if props[prop].location == @name and props[prop].visible == true
        description << "You see a #{props[prop].name}.\n"
      end
    end

    description

  end

  def describe_revealed_exit_data(props)

    description = ''

    if @revealed_exit_data[@name]
      @revealed_exit_data[@name].each do |direction, exit_data|
        prop = exit_data['prop']
        if props[prop].location == @name
          description << "The #{exit_data['prop']} leads #{direction}.\n"
        else
          description << "An exit leads #{direction}.\n"
        end
      end
    end

    description

  end

end
