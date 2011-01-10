module Handles_YAML_Files

  def load_yaml_file(file_path)
    if FileTest.exists?(file_path)
      YAML::load(File.open(file_path))
    end
  end

  def save_data_as_yaml_file(data, file_path)
    File.open(file_path, 'w') { |f| YAML.dump(data, f) }
  end

  def recursive_find_of_yaml_files(path)

    require 'find'

    files = []

    Find.find(path) do |file|

      if !FileTest.directory?(file) and (file.index('.yaml') or file.index('.yml'))

        files << file

      end

    end rescue error "not found any files under #{path}"

    files

  end

  def recursive_find_of_yaml_file_data(path)

    data = []

    recursive_find_of_yaml_files(path).each do |file|

      data << load_yaml_file(file)

    end

    data

  end

end
