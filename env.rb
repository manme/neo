require 'yaml'

file_name = 'env.yml'
YAML.load(File.open(file_name)).each do |key, value|
  ENV[key.to_s] = value.to_s
end if File.exists?(file_name)
