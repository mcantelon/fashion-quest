module Has_Events

  def event(type)

=begin
    if @events
      if @events[type]

        event_response = @events[type][rand(@events[type].length)]

        #alert(event_response)
        alert(locations['alcove'].description)

        begin
          # if evalutation fails, return as string
          result = instance_eval(event_response)

          return result

        rescue SyntaxError, NameError

          alert('erra')
          return event_response
        end
      end
    end
=end

  end

end
