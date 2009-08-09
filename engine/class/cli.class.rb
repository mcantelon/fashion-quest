class Cli

  require 'pathname'

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
    Find.find("#{@game.path}commands") do |command_path|

      if !FileTest.directory?(command_path) and (command_path.index('.yaml') or command_path.index('.yml'))

        # each command is stored in YAML as a hash
        command_data = load_yaml_file(command_path)

        # if no command data has loaded, try to load from shared commands directory
        if not command_data
          command_filename = Pathname.new(command_path).basename
          command_data = load_yaml_file(@game.app_base_path + '/shared_commands/' + command_filename)
        end

        if command_data

          # commands can access the game and image stack
          command = Command.new :game => @game, :image_stack => @image_stack, :output_stack => @output_stack

          # commands have syntax and logic
          command.syntax = command_data['syntax']
          command.logic  = command_data['logic']

          @commands << command

          commands_loaded += 1
        else
          alert('Error: No command data found in ' + command_path + ' (and no command of same name found in shared_commands directory)')
        end

      end
    end

    if commands_loaded < 1

      error('No commands loaded.')
    end

  end

  def keystroke(k)

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
          if @input_text != 'load walkthrough'
            @command_history << @input_text
          end
          issue_command(@input_text)
          display_prompt

        end
      end
    end

  end

  def reset

      @output_text = ''
      @output_stack.clear { }

      @command_history = []

      issue_command('look')
      display_prompt

  end

  def restart

    if restarted = @game.restart

      reset

    else

      @input_text = ''
    end

    restarted

  end

  def issue_command(input_text, show_input = true)

    case input_text

      when 'restart':
        restart

      when 'clear':
        @output_text = ''
        @input_text =  ''

      when 'save walkthrough':
        save_walkthrough

      when 'load walkthrough':
        load_walkthrough

      when 'save transcript':
        save_transcript

      when 'compare to transcript':
        compare_to_transcript

      else

        output_add('>' + input_text) if show_input

        result = parse(input_text)

        # if the result of a command is prefixed with ">", redirect to another command
        if result[0] == ?>
          result = issue_command(result[1..-1], false)
        end

        # execute turn logic if not executing a compound command
        if show_input == true
          @message_text << @game.turn
        end

        @output_text << result
        @input_text  = ''

    end
  end

  def save_walkthrough

    save_data_as_yaml_file(@command_history[0...-1], ask_save_file)
    @output_text << "Walkthrough saved.\n"
    @input_text = ''
  end

  def load_walkthrough

    history_file = ask_open_file

    if history_file

      load_yaml_file(history_file).each do |command|

        issue_command(command)
        display_prompt
      end

    else

      @input_text = ''

    end

  end

  def save_transcript

    if (filename = ask_save_file)
      file = File.new(filename, "w")
      file.write(@output_text)
      file.close

      @output_text << "History saved.\n"
      @input_text = ''
    end
  end

  def compare_to_transcript

    if (filename = ask_open_file)
      transcript = ''
      f = File.open(filename, "r") 
      f.each_line do |line|
        transcript += line
      end

      if (transcript == @output_text)
        @output_text << "Pass!\n"
      else
        @output_text << "Fail!\n"
      end
      @input_text = ''
    end
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
