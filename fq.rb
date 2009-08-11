require 'engine/setup.rb'

Shoes.app(
  :title     => '',
  :width     => 300,
  :height    => 100,
  :resizable => true
) {

  def main(game_selector, app_base_path, game_path, config)

    Shoes.app(
      :title     => config['title'],
      :width     => config['width'],
      :height    => config['height'],
      :resizable => config['resizable']
    ) {

      # Close game selector
      game_selector.close

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
      @cli = Cli.new :output_stack => @output_stack, :image_stack => @image_stack, :game => @game, :initial_text => config['startup_message']
      @cli.issue_command('look', false)
      @cli.display_prompt

      # Set up keystroke processing
      keypress do |k|
        @cli.keystroke(k)
        if @game.over
          @game.restart_or_exit
          @cli.reset
        end
      end
    }

  end

  app_base_path = File.expand_path(File.dirname(__FILE__))

  # can this get factored into an include?
  game_directories = []

  Dir.entries(app_base_path).each do |entry|
    path = app_base_path + '/' + entry
    if path != '.' && path != '..' && FileTest.directory?(path)
      Dir.entries(path).each do |child_entry|
        if child_entry == 'config.yaml'
          game_directories << entry
        end
      end
    end
  end

  para "Choose game:"
  game_select = list_box :items => game_directories
  btn = button 'OK' do
    if game_select.text()
      game_path = app_base_path + '/' + game_select.text() + '/'
      config = File.open("#{game_path}config.yaml", 'r') { |f| YAML::load(f.read) }
      main(app, app_base_path, game_path, config)
    end
  end
}
