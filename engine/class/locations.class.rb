class Locations

  attr_accessor :id, :path, :loaded, :name, :description, :dark, :exits, :description_notes, :image_file

  include Handles_YAML_Files

  # is this function needed?
  def initialize(path)

    @path = path

    # additional description details revealed by player actions get stored here
    @description_notes = {}

  end

  def has_exit(direction)

    if @exits[direction]
      true
    else
      false
    end

  end

  def add_to_description(text)

    @description_notes[@name] ||= ''
    @description_notes[@name] += text

  end

  def describe(doors, props, characters, light = nil)

    if @dark and light != true

     description = "It is too dark to see.\n"

    else

      # describe current location
      description = @description.dup
      description += @description_notes[@name] if @description_notes[@name]

      description << describe_characters(characters)

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
      if characters[character].location == @id
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

end
