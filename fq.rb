require 'yaml'

path = ARGV[1] ? ARGV[1] + '/' : 'game/'

config = File.open("#{path}config.yaml", 'r') { |f| YAML::load(f.read) }

Shoes.app(
  :title     => config['title'],
  :width     => config['width'],
  :height    => config['height'],
  :resizable => config['resizable']
) {

  require 'engine/module/handles_yaml_files.module.rb'
  require 'engine/module/parses_commands.module.rb'
  require 'engine/module/uses_weapons.module.rb'
  require 'engine/module/may_have_name.rb'
  require 'engine/module/has_events.rb'

  require 'engine/class/game.class.rb'
  require 'engine/class/player.class.rb'
  require 'engine/class/character.class.rb'
  require 'engine/class/locations.class.rb'
  require 'engine/class/door.class.rb'
  require 'engine/class/prop.class.rb'
  require 'engine/class/cli.class.rb'
  require 'engine/class/command.class.rb'

  # Initialize image display area
  @image_stack = stack :background => white, :width => 600, :height => 200

  # Initialize output area
  @output_stack = stack :scroll => true, :width => 600, :height => 400
  @output_stack.hide

  # Initialize game
  @game = Game.new path

  # Initialize CLI (showing/hiding the output stack fixes a platform-specific issue)
  @cli = Cli.new :output_stack => @output_stack, :image_stack => @image_stack, :game => @game, :initial_text => config['startup_message']
  @cli.issue_command('look', false)
  @output_stack.show

  # Set up keystroke processing
  keypress do |k|
    @cli.keystroke(k)
  end
}
