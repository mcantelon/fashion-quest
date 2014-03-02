#
# The Has_Events module handles event responses. A random response will
# be selected and executed, if it's logic, or returned as a string, if not.
#

module Has_Events

  def event(type)

    if @events
      if @events[type]

        event_response = @events[type][rand(@events[type].length)]

        # try as logic
        begin

          result = instance_eval(event_response)

          return result

        # if evaluation as logic fails, return as string
        rescue SyntaxError, NameError

          return event_response

        end
      end
    end

  end

end
