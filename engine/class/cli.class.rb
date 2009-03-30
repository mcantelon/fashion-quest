class Cli

  include Parses_Commands
  include Handles_YAML_Files

  def initialize(params)

    require 'find'

    @output_stack = params[:output_stack]
    @image_stack  = params[:image_stack]
    @game         = params[:game]
    @output_text  = params[:initial_text]

    @message_text = ''
    @input_text   = ''

    @command_history = []

    @commands = []
    commands_loaded = 0

    # load all commands, recursively, contained in command directory
    Find.find("#{@game.path}commands") do |command_file|

      if !FileTest.directory?(command_file) and (command_file.index('.yaml') or command_file.index('.yml'))

        # each command is stored in YAML as a hash
        command_data = load_yaml_file(command_file)

        if command_data

          # commands can access the game and image stack
          command = Command.new :game => @game, :image_stack => @image_stack

          # commands have syntax and logic
          command.syntax = command_data['syntax']
          command.logic  = command_data['logic']

          @commands << command

          commands_loaded += 1
        end

      end
    end

    if commands_loaded < 1

      error('No commands loaded.')
    end

  end

  def keystroke(k)

    # allow player to restart if dead
    if @game.over == true
      restart_or_exit(k)
      return
    end

    if k == :backspace

      backspace

    else

      # add keystroke to input
      if k != :enter and k != "\n"
        @input_text << k
      end

      # if there has been input, display prompt
      if not @input_text.empty?
        display_prompt(@input_text)

        # execute command
        if k == :enter or k == "\n"
          @command_history << @input_text
          issue_command(@input_text)

        end
      end
    end

  end

  def restart_or_exit(k)

    case k
      when 'y':
        restart
      when 'n':
        exit()
    end

  end

  def restart

    @game.restart

    @output_text = ''
    @output_stack.clear { }

    @command_history = []

    issue_command('look')
    display_prompt

  end

  def issue_command(input_text, show_input = true)

    case input_text

      when 'restart':
        restart

      when 'clear':
        @output_text = ''
        @input_text =  ''

      else

        character_output = ''

        output_add('>' + input_text) if show_input

        ## execute turn logic if not executing a compound command
        #if show_input == true
        #  @message_text << @game.turn
        #end

        result = parse(input_text)

        # if the result of a command is prefixed with ">", redirect to another command
        if result[0] == ?>
          result = issue_command(result[1..-1], false)
        end

        # execute turn logic if not executing a compound command
        if show_input == true
          @message_text << @game.turn
        end


        @output_text << character_output + result
        @input_text  = ''

    end

    display_prompt

  end

  def backspace

    @input_text = @input_text.length > 1 ? @input_text[0..-2] : ''
    display_prompt(@input_text)

  end

  def display_prompt(input_text = '')

    output(@output_text, '>' + input_text + '#')

    # add message to output text and clear
    @output_text += @message_text
    @message_text = ''

  end

  def output(output_text, input_text = '')

    # display output text, emphasize any messages, and show prompt
    @output_stack.clear {
      @output_stack.para \
        output_text,
        @output_stack.em(@message_text),
        input_text
    }
    @output_stack.scroll_top = @output_stack.scroll_max

  end

  def output_add(text, add_newline = true)
    if add_newline
      @output_text << text + "\n"
    else
      @output_text << text
    end
  end

  def output_error
    return "I don't understand what you want from me.\n"
  end

end
