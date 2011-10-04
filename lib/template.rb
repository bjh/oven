
module Oven
  module Template
    # open and return file that matched the template name
    def self.get(path, ext = '.html.erb')
      # append the extension if it is missing
      if path !~ /#{ext}$/
        path += ext
      end
      
      file = AppConfig.root_path_plus(:templates, path)
      ERB.new(File.open(file, "r:UTF-8").read)
    end
  
    # create a binding around any passed in data (usually a Hash)
    # that can be used by an ERB template
    def self.bind(data)
      bound = OpenStruct.new(data)
      def bound.get_binding()
        binding()
      end
    
      return bound
    end
  end
end