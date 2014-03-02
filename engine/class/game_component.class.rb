#
# The GameComponent class is used as a base class for other classes that
# represent elements in a game.
#

class GameComponent

  include Referred_To_Using_English
  include Has_Events

  attr_accessor :id, :name, :aliases, :description, :location

end
