#
# The Uses_Weapons module allows combat-related properties to be set
# and provides a method that return the best weapons that an entity
# possesses.
#

module Uses_Weapons

  attr_accessor :id, :hp, :strength, :dead, :default_attack

  def determine_best_weapon

    best_weapon          = ''
    best_weapon_strength = 0

    @props.each do |prop_key, prop_data|
      if @props[prop_key].location == id
        if @props[prop_key].traits && @props[prop_key].traits['attack_strength']
          if @props[prop_key].traits['attack_strength'] > best_weapon_strength
            best_weapon = prop_key
            best_weapon_strength = @props[prop_key].traits['attack_strength']
          end
        end
      end
    end

    best_weapon
  end

end
