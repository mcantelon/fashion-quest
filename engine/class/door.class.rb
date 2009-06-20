class Door

  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :description, :locations, :size, :opened, :text, :events, :visible, :traits

  def initialize

    @visible  = true
  end

  def attempt_entry(player, props)

    new_player_location = false

    largest_prop_size = player.largest_carried_item_size

    if @size

      if @size >= largest_prop_size

        new_player_location = destination_from(player.location)

      end
    else
      new_player_location = destination_from(player.location)
    end

    if new_player_location
      player.location = new_player_location
    end

    new_player_location

  end

  def destination_from(location)

    # determine possible destinations
    possible_destinations = @locations.dup
    possible_destinations.delete(location)

    # randomly select a possible destination
    return possible_destinations[rand(possible_destinations.length)]

  end

end
