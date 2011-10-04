
module Oven
  class Generator
    # factory method    
    def self.create(name, options)
      if options.has_key?(:inherits)
        # this is a bit verbose but there was some Hash clobbering happening
        # when inheriting rules, cloning is happening in the inherit_rules method
        inherits = options.delete(:inherits)        
        existing = GeneratorStore.get(inherits)
        incoming = options
        incoming[:rules] = inherit_rules(existing[:rules], incoming[:rules])
        GeneratorStore.inherit(name, inherits, incoming)
      else
        GeneratorStore.put(name, options)
      end
    end
    
    def self.[](name)
     # L::debug("Generator['#{name}']")
      g = GeneratorStore.get(name)
      
      if not g.is_a?(Hash)
        raise ArgumentError.new, "Cannot find Generator named #{name} in the GeneratorStore"
      end
      
      return Generator.new(
        g[:feed], 
        g[:selector], 
        g[:template], 
        g[:rules]
      )
    end
    
    def initialize(feed, selector, template, rules)
      #L::info("Generator.ctor(#{feed}, #{selector}, #{template}, #{rules})")
      @feed = Oven::FeedStore.get(feed)
      @selector = selector
      @template = template
      @rules = rules
    end
  
    def run(&block)
      # for each match of the selector against the feed, apply it to the template
      feed = Feed.new(@feed, @selector)
      feed.consume do |node|
        template_data = create_rules(node)
        
        if @template == :none
          block.call(template_data)
        else
          block.call(Template::get(@template).result(template_data.get_binding()))
        end
      end
    end

  private
    #TODO, slice of the filters from the rules and just pass those in
    def apply_filter(filters, content)
      # anything in the rule arrau form position 2 onwards is a Filter
      filtered = content
      
      # apply each filter in the rules
      filters.each do |filter_name|
        filter = FilterStore.get(filter_name)
        filtered = filter.call(filtered)
      end
      
      filtered
    end
    
    def create_rules(node)
      # refactor to use collect ?
      data = {}
      @rules.each do |rule|
        value = node.at_xpath(rule[1])
        data[rule[0]] = apply_filter(rule.slice(2, rule.size-2), value.content)
      end
      Template::bind(data)
    end
    
    def self.inherit_rules(existing, incoming)
      #L::info("inherit_rules: #{existing.inspect}, #{incoming.inspect}")
      return [] if existing.nil? && incoming.nil?
      return existing if existing && incoming.nil?
      
      # make sure to clone the existing rules so they are not getting clobbered
      rules = Marshal::load(Marshal.dump(existing))

      (0...rules.size).each do |n|
        overwrite = incoming.select do |incoming_rule|
          # is there a matching incoming rule to overwrite?
          incoming_rule[0] == rules[n].first
        end

        if not overwrite.empty?
          rules[n] = overwrite.first
        end
      end
      
      rules
    end
  end
end