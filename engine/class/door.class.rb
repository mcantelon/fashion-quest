class Door

  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :description, :locations, :size, :opens_with, :opened, :get_with, :text, :events, :lit, :visible

  def initialize

    @visible  = true
  end

end
