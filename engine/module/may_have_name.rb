module May_Have_Name

  attr_accessor :name, :proper, :plural

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

    if @name
      name = @name
    else
      name = id
    end

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

end
