module May_Have_Name

  def noun

    if @name
      if @name != ''
        return @name
      end
    end

    'the ' + @id

  end

  def noun_cap

    if @name
      if @name != ''
        return @name
      end
    end

    'The ' + @id

  end

end
