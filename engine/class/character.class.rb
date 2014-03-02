#
# The Character class represents a non-player character. 
#

class Character < GameComponent

  include Uses_Weapons
  include Handles_YAML_Files
  include Has_Events
  include Has_Traits

  attr_accessor :location, :gender, :aggression, \
    :mobility, :exchanges, :discusses, :mutters, :mutter_probability, :hostile, :events, :logic

  def initialize(params)

    @locations = params[:locations]
    @player    = params[:player]
    @props     = params[:props]
    @traits    = {}

  end

  def turn_logic

    character_output = ''

    # if character is in the same location, report any interaction
    if @location == @player.location
      character_output << interact
    end

    # if character hasn't interacted, report any idle actions
    if character_output == ''
      character_output << idle
    end

    # allow ad-hoc character logic
    if @logic
      logic_output = instance_eval(@logic)
      if logic_output
        character_output << logic_output
      end
    end

    character_output

  end

  def interact

    output = ''

    # allow character to mutter
    if mutter_probability && decision(mutter_probability)
      output << mutter
    end

    # inform if character has turned hostile
    if hostile != true
      output << turns_hostile
    end

    # attack if hostile
    if hostile == true
      output << attack
    end

    output

  end

  def idle

    output = ''

    # if the character is mobile, allow wandering
    if mobility && decision(mobility)
      output << wander
    end

    output

  end

  def mutter

    wrap_in_quotes_optionally(mutters[rand(mutters.length)])
  end

  def wander

    output = ''

    # take note of character location and find exits
    character_initial_location = @location

    possible_exits = @locations[@location].exits

    if possible_exits && possible_exits.length > 0

      # pick one of the exits and make it the character's new location
      #chosen_direction = pick_one(possible_exits)
      exit_choice = rand(possible_exits.length)
      chosen_direction = possible_exits.keys[exit_choice]

      if possible_exits[chosen_direction]['destination']

        @location = possible_exits[chosen_direction]['destination']

        # if character was originally in the same place as the player, report movement
        if character_initial_location == @player.location

          # use direction description, if available, to describe where character went
          if possible_exits[chosen_direction]['description']
            direction_description = possible_exits[chosen_direction]['description']
          else
            direction_description = chosen_direction
          end

          output << "#{noun_cap} goes #{direction_description}.\n"

        elsif @location == @player.location

          # if character is now in the same place as the player, report presence
          output << "You see #{noun}.\n"

        end
      end
    end

    output

  end

  def turns_hostile

    output = ''

    # if character can be aggressive, allow decision to attack
    if aggression && decision(aggression)
      @hostile = true
      output << event('on_attack')
      output << "#{noun_cap} attacks!\n"
    end

    output

  end

  def attack

    output = ''
    attack_strength = 2

    # if character has strength, add to attack strength
    if strength
      attack_strength += strength
    end

    # determine best weapon, and add to attack strength
    best_weapon = determine_best_weapon
    if not best_weapon.empty?
      attack_strength += @props[best_weapon].traits['attack_strength']
    elsif default_attack
      best_weapon = default_attack
    else
      best_weapon = 'punches and kicks'
    end

    # calculate damage based on attack strength
    damage = rand(attack_strength)

    # report damage or miss
    if damage > 0
      output << "#{noun_cap} attacked with #{best_weapon} for #{damage.to_s} HP.\n"
    else
      output << "#{noun_cap} attacked, but did no damage.\n"
    end

    # damage player accordingly and report
    if @player.hp
      @player.hp = @player.hp - damage
      if @player.hp > 0
        output << "You now have #{@player.hp.to_s} HP.\n"
      end
    end

    output

  end

  def kill

    # make character passive
    @hostile    = false
    @mobility   = 0
    @aggression = 0

    # mark character as dead
    @dead = true

    event('on_death')

  end

  def decision(likelihood)

    happenstance = rand(100) + 1

    (happenstance <= likelihood) ? true : false

  end

  def attempt_exchange(prop)

    output = ''

    # if character is willing to trade for prop, drop items of exchange
    if @exchanges && @exchanges[prop]
      if @events && @events['on_exchange']
        output << event('on_exchange')
      end
      if output == ''
        output << "#{noun_cap} takes the #{prop}.\n"
      end
      if @exchanges[prop].class == Array
        @exchanges[prop].each do |drop_prop|
          output << "#{noun_cap} drops #{@props[drop_prop].noun_direct}.\n"
          @props[drop_prop].location = @player.location
          @hostile = false
        end
      end
      @props[prop].location = @id
    end

    output

  end

  def wrap_in_quotes_optionally(statement)

    if statement[0,1] == '>'
      "\"#{statement[1,5000]}\"\n"
    else
      "#{statement}\n"
    end

  end

  def discuss(topic)

    output = ''

    # if character talks and isn't hostile, check topics
    if @discusses and not @hostile and not @dead

      @discusses.each do |topics, responses|

        # if a topic matches, randomly pick from related responses
        if topics.index(topic) != nil
          output << event('on_discuss')
          response = responses[rand(responses.length)]
          output << wrap_in_quotes_optionally(response)
        end
      end
    end

    output
  end

end
