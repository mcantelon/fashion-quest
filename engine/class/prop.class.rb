class Prop

  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :description, :location, :opened, \
    :text, :attack_strength, :events, :traits

  def initialize

    @traits = {}
  end

end
