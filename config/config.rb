require 'yaml'
# require 'app_config'

AppConfig = YAML.load(File.open("#{File.dirname(__FILE__)}/config.yml").read)

AppConfig.keys.each do |key|
  AppConfig[(key.to_sym rescue key) || key] = AppConfig.delete(key)
end

# app specific Config helpers
def AppConfig.root_path_plus(path, *rest)
  #puts "AppConfig.root_path_plus(#{path}, #{rest})"
  # use symbol as in index into the congig
  # OR just make a directory path
  p = AppConfig[:approot]
  
  ([path] + rest).each do |dir|
    if dir.is_a?(Symbol)
      p += "/#{AppConfig[dir]}"
    else
      p += "/#{dir}"
    end
  end
  
  return Oven::Path.slash(p)  
end
