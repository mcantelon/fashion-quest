class Player

  include Uses_Weapons

  attr_accessor :name, :location

  def initialize(params)

    @name     = params[:name]
    @hp       = params[:hp]
    @strength = params[:strength]
    @dead     = params[:dead]
    @location = params[:location]

    @props      = params[:props]
    @characters = params[:characters]

  end

  def carried

    items = []

    @props.each do |id, prop|
      (items << prop) if @props[id].location == 'player'
    end

    @characters.each do |id, character|
        (items << character) if @characters[id].location == 'player'
    end

    items

  end

  def carrying(prop = '')

    inventory ||= []

    carried.each do |object|

      if object.id == prop
        return true
      end

      inventory << object

    end

    if prop == ''
      inventory
    else
      false
    end
  end

  def can_build(prop)

    can_build = true

    @props[prop].traits['build_with'].each do |component|
      if !carrying(component) and @props[component].location != @location
        can_build = false
      end
    end

    can_build

  end

  def can_dig

    can_dig = false

    carrying.each do |prop|
      if prop.traits
        if prop.traits['can_dig']
          can_dig = true
        end
      end
    end

    can_dig

  end

  def dig

    output = ''

    @props.each do |prop, data|
      if data.location == @location
        if data.traits['buried']
          @props[prop].traits['buried']   = false
          @props[prop].traits['portable'] = true
          @props[prop].traits['visible']  = true

          output << "You found something!\n"
        end
      end
    end

    output

  end

  def build(prop)

    @props[prop].traits['build_consumes'].each do |component|
      @props[component].location = ''
    end

    @props[prop].location = @location

  end

  def largest_carried_item_size

    largest_size = 0

    carrying.each do |prop|

      if prop.traits['size']

        if prop.traits['size'] > largest_size

          largest_size = prop.traits['size']
        end
      end
    end

    largest_size
  end

  def has_prop_with_trait(trait, value = nil)

    carried.each do |prop|

      # comment this, eh
      if prop.traits[trait]
        if value != nil
          if prop.traits[trait] == value
            return true
          end
        else
          return true
        end
      end
    end

    false
  end

  def has_lit_item
    has_prop_with_trait('lit', true)
  end

end
