
module Oven
  class PageBase
    #attr_accessor :html
  
    def initialize(options)
      @options = options
      @header = options[:header] || AppConfig[:header]
      @footer = options[:footer] || AppConfig[:footer]
      @body = []
    end
  
    # derived classes must implement this
    def generate
      throw "override me before innocent kittens are hurt!"
    end
  
    def body(content)
      @body << content
    end
  
    def write
      data = Template::bind(@options)
      header = Template::get(@header).result(data.get_binding())
      body = @body.join('')
      footer = Template::get(@footer).result(data.get_binding())
    
      content = [header, body, footer].join('')
    
      path = File.join(AppConfig[:output_directory], @options[:path], 'index.html')
      #L::info("WRITING FILE TO: #{path}")
      Path.create(File.dirname(path))
      File.open(path, 'w+') { |file| file.write(content) }
    end
  end
end