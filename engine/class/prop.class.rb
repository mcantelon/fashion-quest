class Prop < GameComponent

  include May_Have_Name
  include Has_Events
  include Has_Traits

  attr_accessor :location, :attack_strength, :events

  def initialize

    @traits = {}
  end

end
