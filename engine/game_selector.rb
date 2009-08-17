def game_selector(app, app_base_path)

  game_directories = game_selector_directories(app_base_path)

  if game_directories.size == 1

    game_selector_launch(app, app_base_path, game_directories.first)

  else

    text       = para "Choose game:"
    text.align = 'center'

    game_select = list_box :items => game_directories

    btn = button 'OK' do
      if game_select.text()
        game_selector_launch(app, app_base_path, game_select.text())
      end
    end

  end

end

def game_selector_launch(app, app_base_path, game_directory)

  game_path = app_base_path + '/' + game_directory + '/'
  config = File.open("#{game_path}config.yaml", 'r') { |f| YAML::load(f.read) }
  main(app, app_base_path, game_path, config)

end

def game_selector_directories(app_base_path)

  game_directories = []

  # Scan each directory in the application directory for a config.yaml file
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

  game_directories

end
