error('loaded cli')

class Cli

  require 'pathname'

  include Parses_Commands
  include Handles_YAML_Files

  attr_accessor :prompt, :cursor, :command_condition, :commands

  def initialize(params)

    require 'find'

    @prompt = '>'
    @cursor = '#'

    @output_stack      = params[:output_stack]
    @image_stack       = params[:image_stack]
    @game              = params[:game]
    @output_text       = params[:initial_text]

    @command_condition = params[:command_condition]

    @standard_commands = params[:standard_commands]

    @command_abbreviations = params[:command_abbreviations]
    @garbage_words         = params[:garbage_words]
    @global_synonyms       = params[:global_synonyms]

    if !@command_abbreviations
      load_abbreviations
    end

    if !@garbage_words
      load_garbage_words
    end

    if !@global_synonyms
      synonyms_file = "#{@game.path}parsing/global_synonyms.yaml"
      @global_synonyms = load_yaml_file(synonyms_file)
    end

    # add loading

    @message_text = ''
    @input_text   = ''

    initialize_commands

  end

  def load_abbreviations

    abbreviations_file = "#{@game.path}parsing/command_abbreviations.yaml"
    @command_abbreviations = load_yaml_file(abbreviations_file)

  end

  def load_garbage_words

    @garbage_words = load_yaml_file("#{@game.path}parsing/garbage_words.yaml")

  end

  def initialize_commands

    @command_history = []
    @command_index   = 0

    @commands = {}
    commands_loaded = 0

    command_paths = []

    standard_command_path = @game.app_base_path + '/standard_commands'

    # any standard commands listed in a game's config.yaml should be loaded
    if @standard_commands
      @standard_commands.each do |command|
        command_paths << (standard_command_path + '/' + command + '.yaml')
      end
    end

    # any commands contained in command directory (including subdirectories)
    # should be loaded
    Find.find("#{@game.path}commands") do |command_path|
      command_paths << command_path
    end

    # load commands
    command_paths.each do |command_path|

      if !FileTest.directory?(command_path) and (command_path.index('.yaml') or command_path.index('.yml'))

        # each command is stored in YAML as a hash
        command_data = load_yaml_file(command_path)

        # if no command data has loaded, try to load from standard commands directory
        if not command_data
          command_filename = Pathname.new(command_path).basename
          command_data = load_yaml_file(standard_command_path + '/' + command_filename)
        end

        if command_data

          # create command identifier based on filename
          command_id = command_path.split('/').last.sub('.yaml', '')

          # commands can access the game and image stack
          command = Command.new :id => command_id, :game => @game, :image_stack => @image_stack, :output_stack => @output_stack

          # commands have syntax and logic
          command.condition = command_data['condition']
          command.syntax    = command_data['syntax']
          command.logic     = command_data['logic']

          @commands[command.id] = command

          commands_loaded += 1
        else
          alert('Error: No command data found in ' + command_path + ' (and no command of same name found in standard_commands directory)')
        end

      end
    end

    if commands_loaded < 1

      error('No commands loaded.')
    end

  end

  # the flow of this function seems weird
  def keystroke(k)

    if k == :backspace

      backspace

    else

      # add keystroke to input
      if k.class != Symbol and k != "\n"
        @input_text << k
      end

      if k == :up and @command_index > 0
        @command_index = @command_index - 1
        @input_text = @command_history[@command_index]
      end

      if k == :down and @command_index < @command_history.size
        @command_index = @command_index + 1
        if @command_index == @command_history.size
          @input_text = ''
        else
          @input_text = @command_history[@command_index]
        end
      end

      display_prompt(@input_text)

      # execute command
      if k == :enter or k == "\n"
        if @input_text != 'load walkthrough'
          @command_history << @input_text
          @command_index = @command_history.size
        end
        issue_command(@input_text)
        display_prompt
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

      when 'load':
        @game.load(ask_open_file)
        output_add("Game loaded.")
        @input_text = ''

      when 'save':
        @game.save(ask_open_file)
        output_add("Game saved.")
        @input_text = ''

      when 'save walkthrough':
        save_walkthrough

      when 'load walkthrough':
        load_walkthrough

      when 'save transcript':
        save_transcript

      when 'run script':
        run_script

      when 'compare to transcript':
        compare_to_transcript

      else

        output_add(@prompt + input_text) if show_input

        result = parse(input_text, @command_abbreviations, @garbage_words, @global_synonyms)

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

  def run_script

    if (filename = ask_open_file)

      File.open(filename, 'r') do |f|
        instance_eval(f.read)
      end

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

    output(@output_text, @prompt + input_text + @cursor)

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
        input_text,
        :font => 'Verdana 11px',
        :stroke => '#120E03',
        :margin_left => 10,
        :margin_right => 10
    }
    @output_stack.scroll_top = @output_stack.scroll_max

  end

  def output_add(text, add_newline = true)

    optional_newline = add_newline ? "\n" : ''

    @output_text << text + optional_newline

  end

  def output_error
    return "I don't understand what you want from me.\n"
  end

end
