module Referred_To_Using_English

  attr_accessor :name, :proper, :plural

  def noun_base

    if @name
      name = @name
    else
      name = @proper == true ? id.capitalize : id
    end

    name

  end

  def noun(specific = true)

    output = ''

    if specific
      prefix = 'the'
    else
      prefix = @plural == true ? 'some' : 'a'
    end

    name = noun_base

    if name != ''

      if @proper != true
        output << (prefix + ' ')
      end

      output << name

    end

    output

  end

  def noun_cap

    noun.capitalize

  end

  def noun_direct

    noun(false)

  end

  def noun_direct_cap

    noun(false).capitalize

  end

  def noun_direct_specific

    name = ''

    if not @proper

      name << 'the '
    end

    name << noun_base

  end

  def noun_direct_specific_cap

    noun_direct_specific.capitalize

  end

end
