class Prop < GameComponent

  include May_Have_Name
  include Has_Events

  attr_accessor :attack_strength, :events, :traits

  def initialize

    @traits = {}
  end

end
