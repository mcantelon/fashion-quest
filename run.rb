require 'engine/setup.rb'

Shoes.app(
  :title     => '',
  :width     => 300,
  :height    => 100,
  :resizable => true
) {

  # Main loop of game
  def main(game_selector_window, app_base_path, game_path, config)

    Shoes.app(
      :title     => config['title'],
      :width     => config['width'],
      :height    => config['height'],
      :resizable => config['resizable']
    ) {

      # Close game selector
      game_selector_window.close

      if (config['background'])
        background config['background']
      end

      # Initialize image display area
      @image_stack = stack :background => white,
        :width => config['width'],
        :height => config['image_height']

      # Initialize output area
      @output_stack = stack :scroll => true,
        :width => config['width'],
        :height => (config['height'] - config['image_height'])

      # Initialize game
      @game = Game.new(config, app_base_path, game_path)

      # Initialize CLI (showing/hiding the output stack fixes a platform-specific issue)
      @cli = Cli.new :output_stack => @output_stack,
        :image_stack => @image_stack,
        :game => @game,
        :initial_text => config['startup_message'],
        :standard_commands => config['standard_commands'],
        :command_abbreviations => config['command_abbreviations'],
        :garbage_words => config['garbage_words'],
        :global_synonyms => config['global_synonyms']

      if config['command_condition']
        @cli.command_condition = config['command_condition']
      end

      # Allow startup logic to be supplied as raw logic and/or a file
      custom_startup_logic = false

      # Include start logic from file, if one exists
      path_to_startup_logic = game_path + '/startup_logic.rb'
      if File.file?(path_to_startup_logic)
        require(path_to_startup_logic)
        custom_startup_logic = true
      end

      # Include startup logic form config, if specified
      if config['startup_logic']
        instance_eval(config['startup_logic'])
        custom_startup_logic = true
      end

      # if no startup logic has been specified, issue 'look' command
      if !custom_startup_logic
        @cli.issue_command('look', false)
      end

      # Display CLI prompt
      @cli.display_prompt

      # Process keystrokes
      keypress do |k|
        @cli.keystroke(k)
        if @game.over
          if @game.score
            @cli.output_add(@game.score_total(@game.turns))
            @cli.display_prompt
           end

          @game.restart_or_exit
          @cli.reset
        end
      end
    }

  end

  # Application path is the directory in which this file lives
  app_base_path = File.expand_path(File.dirname(__FILE__))

  # Allow player to select game, if applicable, before proceeding to main loop
  game_selector(app, app_base_path)

}
