require 'app_config'

AppConfig.setup do |config|
  config[:storage_method] = :yaml
  config[:path] = "#{File.dirname(__FILE__)}/config.yml"
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
