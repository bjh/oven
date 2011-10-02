
module Oven
  class Generator
    
    def self.create(name)
      g = GeneratorStore.get(name)
      
      if not g.is_a?(Hash)
        raise ArgumentError.new, "Cannot find Generator named #{name} in the GeneratorStore"
      end
      
      return Generator.new(
        g[:feed], 
        g[:selector], 
        g[:template], 
        g[:variables]
      )
    end
    
    def initialize(feed, selector, template, variables, options={})
      #L::info("Generator.ctor(#{feed}, #{selector}, #{template}, #{variables})")
      @feed = Oven::FeedStore.get(feed)
      @selector = selector
      @template = template
      @variables = variables
    end
  
    def run(&block)
      # for each match of the selector against the feed, apply it to the template
      feed = Feed.new(@feed, @selector)
      feed.consume do |node|
        template_data = create_variables(node)
        
        if @template == :none
          block.call(template_data)
        else
          block.call(Template::get(@template).result(template_data.get_binding()))
        end
      end
    end
  private
    def create_variables(node)
      data = {}
      @variables.each do |rule|
        value = node.at_xpath(rule[1])
        data[rule[0]] = value.content
      end
      Template::bind(data)
    end
  end
end