

module Oven
  # ye old command pattern-esque thing-a-ma-jig
  class Filter
    def self.create(name, options)
      if not options.has_key?(:use)
        raise ArgumentError.new, "Pages.filter not told what to :use"
      else
        if options[:use].is_a?(String)
          klass = options[:use]
        
          if Object.const_defined?(klass)
            filter = Object.const_get(klass)
            Oven::FilterStore.put(name, filter.new)
          else
            L::error("filter: #{name}, no corresponding class file found.")
          end        
        elsif options[:use].is_a?(Proc)
          Oven::FilterStore.put(name, options[:use])
        else
          L::error("filter: #{name}, cannot :use #{options[:use]} as a Filter.")
        end
      end
    end
    
    # Filter objects need to be callable
    def call
      raise "beware of dog!"
    end
  end
end