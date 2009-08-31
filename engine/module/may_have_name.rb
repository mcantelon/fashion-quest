module May_Have_Name

  attr_accessor :name, :proper, :plural

  def noun

    output = ''

    if @name

      if @name != ''

        if proper != true
          output << 'the '
        end

        output << @name

        if plural == true
          output << 's'
        end

        return @name
      end
    else

      output << ('the ' + @id)

    end

    output

  end

  def noun_cap

    noun.capitalize

  end

end
