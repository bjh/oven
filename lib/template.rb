
module Oven
  module Template
    def self.get(path, ext = '.html.erb')
      #TODO: use ext for the regex test
      if path !~ /\.html\.erb$/
        path += ext
      end
    
      file = AppConfig.root_path_plus(:templates, path)
      ERB.new(File.open(file, "r:UTF-8").read)
    end
  
    def self.bind(data)
      bound = OpenStruct.new(data)
      def bound.get_binding()
        binding()
      end
    
      return bound
    end
  end
end