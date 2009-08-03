app_base_path = File.expand_path(File.dirname(__FILE__))
path          = ARGV[1] ? ARGV[1] + '/' : 'game/'

if not File.directory? path
  path = app_base_path + '/' + path
end

require 'engine/setup.rb'

config = File.open("#{path}config.yaml", 'r') { |f| YAML::load(f.read) }

Shoes.app(
  :title     => config['title'],
  :width     => config['width'],
  :height    => config['height'],
  :resizable => config['resizable']
) {

  # Initialize image display area
  @image_stack = stack :background => white,
    :width => config['width'],
    :height => config['image_height']

  # Initialize output area
  @output_stack = stack :scroll => true,
    :width => config['width'],
    :height => (config['height'] - config['image_height'])
#  @output_stack.hide

  # Initialize game
  @game = Game.new(config, app_base_path, path)

  # Initialize CLI (showing/hiding the output stack fixes a platform-specific issue)
  @cli = Cli.new :output_stack => @output_stack, :image_stack => @image_stack, :game => @game, :initial_text => config['startup_message']
  @cli.issue_command('look', false)
#  @output_stack.show
  @cli.display_prompt

  # Set up keystroke processing
  keypress do |k|
    @cli.keystroke(k)
  end
}
