class Door < GameComponent

  include Has_Events
  include Has_Traits

  attr_accessor :locations, :size, :text, :events, :visible

  def initialize

    @visible  = true
    @traits = {}
  end

  def attempt_entry(player, props)

    new_player_location = false

    largest_prop_size = player.largest_carried_item_size

    # explain this in a comment, eh
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
