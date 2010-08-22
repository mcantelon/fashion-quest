module Referred_To_Using_English

  attr_accessor :name, :proper, :plural

  # unprefixed noun
  def noun_base

    # if a name is specified, use it
    if @name
      name = @name
    else
    # ...otherwise, use unique ID (capitalizing it if noun is proper)
      name = @proper == true ? id.capitalize : id
    end

    name

  end

  def noun

    noun_with_prefix('the')

  end

  def noun_cap

    noun.capitalize

  end

  def noun_direct

    prefix = @plural == true ? 'some' : 'a'

    noun_with_prefix(prefix)

  end

  def noun_direct_cap

    noun_direct.capitalize

  end

  def noun_with_prefix(prefix)

    output = ''

    if @proper != true
      output << (prefix + ' ')
    end

    name = noun_base

    output << ((name != '') ? name : '')

    output

  end

end
