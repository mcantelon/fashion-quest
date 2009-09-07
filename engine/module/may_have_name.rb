module May_Have_Name

  attr_accessor :name, :proper, :plural

  def noun_base

    if @name
      name = @name
    else
      if @proper == true
        name = id.capitalize
      else
        name = id
      end
    end

    name

  end

  def noun(specific = true)

    output = ''

    if specific
      prefix = 'the'
    else
      if @plural == true
        prefix = 'some'
      else
        prefix = 'a'
      end
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
