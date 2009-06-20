class Prop < GameComponent

  include May_Have_Name
  include Has_Events

  attr_accessor :location, :attack_strength, :events, :traits

  def initialize

    @traits = {}
  end

end
