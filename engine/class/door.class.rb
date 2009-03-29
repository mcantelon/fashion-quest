class Door

  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :description, :locations, :size, :opens_with, :opened, :get_with, :text, :events, :lit, :visible

  def initialize

    @visible  = true
  end

  def destination_from(location)

    # determine possible destinations
    possible_destinations = @locations.dup
    possible_destinations.delete(location)

    # randomly select a possible destination
    return possible_destinations[rand(possible_destinations.length)]

  end

end
