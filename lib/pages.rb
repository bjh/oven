
module Oven
  # parser/engine for the DSL
  FeedStore = Oven::ItemStore.new
  GeneratorStore = Oven::ItemStore.new
  FilterStore = Oven::ItemStore.new
  StringStore = Oven::ItemStore.new
  
  # put that frog down! bad monkey....
  class ::String
    # allow a shortcut for the application root path in the DSL
    # example: ~"test-feeds/lotto.xml"
    # override unary ~ for strings
    def ~@
      AppConfig.root_path_plus(self)
    end
    
    # clean up after the bad monkey
    def self.spank_monkey
      undef_method(:~@)
    end
  end
  
  
  class Pages
    ROOT = '/'
    attr_reader :tree
    
    def initialize(script)
      @path = []
      @tree = Tree::TreeNode.new("/", {})
      @root = @tree
         
      begin
        # the magic happens right here people....
        # so do a lot of the exceptions ;)
        instance_eval(File.open(script).read)
      rescue => e
        L::error("PAGES: #{e}")
        L::error("#{e.backtrace.join("\n")}")
      end
      
      # we are done, spank the monkeys
      String::spank_monkey()
    end

private
    def feeds(list)
      FeedStore.merge(list)
    end
    
    def feed(item)
      FeedStore.merge(item)
    end
    
    def dumpfeeds
      puts '-' * 60
      puts '-FEEDS-'
      puts FeedStore.to_s
    end
    
    def dumptree
      puts '-' * 60
      puts '-PAGE STUCTURE-'
      @root.print_tree 
    end
    
    def dumpfilters
      puts '-' * 60
      puts '-FILTERS-'
      puts FilterStore.to_s
    end
    
    def dumpgenerators
      puts '-' * 60
      puts '-GENERATORS-'
      puts GeneratorStore.to_s
    end
    
    def filter(name, options={})
      #L::info("filter: #{name}, #{options}")
      begin
        Filter::create(name, options)
      rescue => e
        L::error("Pages.filter: #{e}")
        L::error("#{e.backtrace.join("\n")}")
      end
    end
    
    def generator(name, options)
      begin
        Oven::Generator::create(name, options)
      rescue => e
        L::error("Pages.generator: #{e}")
        L::error("#{e.backtrace.join("\n")}")
      end
    end
    
    def page(path, options={}, &block)
      #L::info("page: #{path}, #{options.keys.join('|')}, #{@path}")
      crumbs = (@path + [path]).join('/')
      options = {
        path:crumbs,
        name:path
      }.merge(options)
      
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
  end
end