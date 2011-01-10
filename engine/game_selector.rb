def game_selector(app, app_base_path)

  game_directories = game_selector_directories(app_base_path)

  stack do

    if game_directories.size == 1

      message = "Loading " + game_directories.first
      game = game_directories.first

    else

      message = "Choose game:"

    end

    text       = para message
    text.align = 'center'

    if !game
      game_select = list_box :items => game_directories
    end

    btn = button 'OK' do
      if game || game_select.text()
        load_game = game ? game : game_select.text()
        game_selector_launch(app, app_base_path, load_game)
      end
    end
  end
end

def game_selector_launch(app, app_base_path, game_directory)

  game_path = app_base_path + '/games/' + game_directory + '/'
  config = File.open("#{game_path}config.yaml", 'r') { |f| YAML::load(f.read) }
  main(app, app_base_path, game_path, config)

end

def game_selector_directories(app_base_path)

  game_directories = []
  game_directory = app_base_path + '/games'

  # Scan each directory in the application directory for a config.yaml file
  Dir.entries(game_directory).each do |entry|
    path = game_directory + '/' + entry
    if path != '.' && path != '..' && FileTest.directory?(path)
      Dir.entries(path).each do |child_entry|
        if child_entry == 'config.yaml'
          game_directories << entry
        end
      end
    end
  end

  game_directories

end
