class Location

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

      # describe current location, including any additions added during game play
      description = @description.dup
      description += @description_notes[@name] if @description_notes[@name]

      # specify visibility conditions for different types of game components
      components_to_describe = {
        characters => "components[component_id].location == @id",
        doors      => "components[component_id].locations.include?(@id)",
        props      => "components[component_id].location == @id and components[component_id].traits['visible'] == true"
      }

      # figure out which game components are visible in this location
      visible_components = []

      components_to_describe.each do |components, visibility_condition|

        visible_components |= components_seen(components, visibility_condition)

      end

      # add a listing of the visible components to the location description
      description += describe_game_components(visible_components)

    end

    description

  end

  def components_seen(components, visibility_condition)

    components_seen = []

    components.each do |component_id, component_data|
      if eval(visibility_condition)
        components_seen << components[component_id].noun_base
      end
    end

    components_seen

  end

  def describe_game_components(components)

    output = ''

    if components.size > 0

      output << "You see: "

      component_output = ''

      components.each do |component|

        if component_output != ''
           component_output << ', '
        end

        component_output << component

      end

      component_output << ".\n"

      output << component_output

    end

    output

  end

end
