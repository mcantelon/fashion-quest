module Handles_YAML_Files

  def load_yaml_file(file_path)
    if FileTest.exists?(file_path)
      File.open(file_path, 'r') { |f| YAML::load(f.read) }
    end
  end

  def save_data_as_yaml_file(data, file_path)
    File.open(file_path, 'w') { |f| YAML.dump(data, f) }
  end

end
