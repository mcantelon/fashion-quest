class Prop

  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :description, :location, :weight, :size, :portable, :contains, :opens_with, :opened, \
    :get_with, :build_with, :text, :attack_strength, :events, :visible, :traits

  def initialize

    @portable = true
    @visible  = true
    @traits   = {}
  end

end
