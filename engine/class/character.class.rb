class Character

  include Uses_Weapons
  include Handles_YAML_Files
  include May_Have_Name
  include Has_Events

  attr_accessor :id, :name, :gender, :description, :location, :hp, :aggression, :strength, \
    :mobility, :exchanges, :discusses, :dead, :hostile, :events, :logic

  def initialize(params)

    @locations = params[:locations]
    @player    = params[:player]
    @props     = params[:props]

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
    if mobility
      if decision(mobility)
        output << wander
      end
    end

    output

  end

  def wander

    output = ''

    # take note of character location and find exits
    character_initial_location = @location

    character_location = @locations[@location]

    # add exits created during the game, if any
    if @locations[@location].revealed_exits
      possible_exits = character_location.exits.merge(@locations[@location].revealed_exits)
    else
      possible_exits = character_location.exits
    end

    if possible_exits.length > 0

      # pick one of the exits and make it the character's new location
      exit_choice = rand(possible_exits.length)
      chosen_direction = possible_exits.keys[exit_choice]
      @location = possible_exits[chosen_direction]

      # if character was originally in the same place as the player, report movement
      if character_initial_location == @player.location
        output << "#{noun_cap} goes #{chosen_direction}.\n"
      end
    end

    output

  end

  def turns_hostile

    output = ''

    # if character can be aggressive, allow decision to attack
    if aggression
      if decision(aggression)
        @hostile = true
        output << event('on_attack')
        output << "#{noun_cap} attacks!\n"
      end
    end

    output

  end

  def attack

    output = ''
    attack_strength = 0

    # if character has strength, add to attack strength
    if strength
      attack_strength += strength
    end

    # determine best weapon, and add to attack strength
    best_weapon = determine_best_weapon
    if not best_weapon.empty?
      attack_strength += @props[best_weapon].attack_strength
    else
      best_weapon = 'fists'
    end

    # calculate damage based on attack strength
    damage = rand(attack_strength)

    # report damage or miss
    if damage > 0
      output << "#{noun_cap} attacked with #{best_weapon} for #{damage.to_s} HP.\n"
    else
      output << "#{noun_cap} attacked, but missed.\n"
    end

    # damage player accordingly and report
    @player.hp = @player.hp - damage
    output << "You now have #{@player.hp.to_s} HP.\n"

    # report if player has been killed
    #if @player.hp < 1
    #  output << "You are dead.\n"
    #  @player.dead = true
    #end

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
    if @exchanges
      if @exchanges[prop]
        if @events
          if @events['on_exchange']
            output << event('on_exchange')
          end
        else
          output << "#{noun_cap} takes the #{prop}.\n"
        end
        if @exchanges[prop].class == 'Array'
          @exchanges[prop].each do |prop|
            alert('coot')
            output << "#{noun_cap} drops a #{prop}.\n"
            @props[prop].location = @player.location
            @hostile = false
          end
        end
      end
    else
      output << "#{noun_cap} doesn't seem interested.\n"
    end

    output

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
          output << "\"#{response}\"\n"
        end
      end
    end

    output
  end

end

