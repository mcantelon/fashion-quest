class Player

  include Uses_Weapons

  attr_accessor :name, :location, :hp, :strength, :dead

  def initialize(params)

    @name     = params[:name]
    @hp       = params[:hp]
    @strength = params[:strength]
    @dead     = params[:dead]
    @location = params[:location]

    @props = params[:props]

  end

  def items

    items = []

    @props.each do |id, prop_data|
      (items << id) if @props[id].location == 'player'
    end

    items
  end

  def carrying(prop = '')

    inventory ||= []

    items.each do |id, prop_data|

      if id == prop
        return true
      end

      inventory << id

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
      if @props[prop].traits
        if @props[prop].traits['can_dig']
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
          @props[prop].traits['buried'] = false
          @props[prop].portable = true
          @props[prop].visible = true

          output << "You found something!\n"
        end
      end
    end

    output

  end

  def build(prop)

    return

    @props[prop].traits['build_with'].each do |component|
      @props[component].location = ''
    end

    @props[prop].location = @location

  end

  def largest_carried_item_size

    largest_size = 0

    carrying.each do |prop|

      if @props[prop].traits['size']

        if @props[prop].traits['size'] > largest_size

          largest_size = @props[prop].traits['size']
        end
      end
    end

    largest_size
  end

  # get rid of
  def has_prop_with_attribute(attribute, value = nil)

    items.each do |id, prop_data|

      if eval('@props[id].' + attribute)
        if value != nil
          if eval('@props[id].' + attribute) == value
            return true
          end
        else
          return true
        end
      end
    end

    false
  end

  def has_prop_with_trait(trait, value = nil)

    items.each do |id, prop_data|

      if @props[id].traits[trait]
        if value != nil
          if @props[id].traits[trait] == value
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

