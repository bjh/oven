
module Oven
  # parser/engine for the DSL
  FeedStore = Oven::ItemStore.new
  GeneratorStore = Oven::ItemStore.new
  
  #class GeneratorNotFound < Exception; end
  
  class Pages
    ROOT = '/'
    attr_reader :tree
    
    def initialize(script)
      @path = []
      #@feeds = {}
      #@generators = {}
      @tree = Tree::TreeNode.new("/", {})
      @root = @tree
            
      begin
        instance_eval(File.open(script).read)
      rescue => e
        L::error("PAGES: #{e.backtrace.join("\n")}")
      end
    end

private
    def feeds(list)
      FeedStore.merge(list)
    end
    
    def feed(item)
      FeedStore.merge(item)
    end
    
    def dumpfeeds
      puts '-' * 50
      puts '-FEEDS-'
      puts FeedStore.to_s
    end
    
    def dumptree
      #puts "#{@feeds}"
      @root.print_tree 
      # puts '-' * 60
      # @root.each { |node| puts("#{node.name} > #{node.content}") }
      # @root.each { |node| puts("#{node.name}") }
      # puts '-' * 60
      # @root.breadth_each { |node| puts("#{node.name}") }
      # puts '-' * 60
      # @root.preordered_each { |node| puts("#{node.name}") }
    end
    
    def generator(name, inherits=false, options)
      begin
        if inherits
          #@generators[name] = @generators[inherits].merge(options)
          GeneratorStore.inherit(name, inherits, options)
        else
          #@generators[name] = options
          GeneratorStore.put(name, options)
        end
      rescue => e
        L::error("Pages.generator: #{e}")
      end
    end
    
    def page(path, options={}, &block)
      #L::info("page: #{path}, #{options.keys.join('|')}, #{@path}")
      crumbs = (@path + [path]).join('/')
      options = {
        path:crumbs,
        name:path
      }.merge(options)
      
      #options = solidify_feed(options)
      #options = solidify_generators(options)

      # ROOT is special, like cousin Reggie
      if path == Pages::ROOT
        @root.content = options
      else
        current = @tree
        child = Tree::TreeNode.new(path, options)
        @tree << child
      end
                  
      @path.push(path) if path !~ /\//
      @tree = child if child
      instance_eval(&block) if block_given?
      @tree = current if current
      @path.pop()
    end
    
    # convert convert each generator description into an actual generator
    # def solidify_generators(options)
    #       generators = {}
    #       
    #       if options[:generators]
    #         options[:generators].each do |name|
    #           g = @generators[name]
    #           
    #           if g.nil?
    #             raise GeneratorNotFound.new, "'#{name}' generator not found"
    #           end
    #           
    #           begin
    #             generators[name] = Oven::Generator.new(
    #               g[:feed], 
    #               g[:selector], 
    #               g[:template], 
    #               g[:variables]
    #             )
    #           rescue => e
    #             L::error("solidify_generators: #{e}")
    #           end
    #         end
    #         options[:generators] = generators
    #       end
    #       options
    #     end
  end
end