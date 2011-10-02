
module Oven
  # process the data created by the Pages DSL
  class SiteEngine
    def initialize(structure_tree)
      @tree = structure_tree
      @deferred = []
    end
  
    def generate
      begin
        process(@tree)
        # reverse the deferred queue so it's LIFO
        process(@deferred.reverse)
      rescue => e
        L::error(e)
      end
    end
  
  private

    def process(pages)
      pages.each do |page|
        data = page.content
            
        if data.has_key?(:defer)
          # delete so this test only happens once
          page.content.delete(:defer)
          @deferred.push(page)
        else
          generate_page(data)
        end
      end
    end

    def generate_page(data)
      # use existing class or default to a generic page
      klass = classname(data)
    
      begin
        if Object.const_defined?(klass)
          page = Object.const_get(klass)
          #TODO: make sure page/klass is_a?(BasicPage)
          page.new(data).generate()
        else
          Static.new(data).generate
        end
      rescue => e
        L::error("generate_page: #{data}")
        L::error(e.backtrace.join("\n"))
      end
    end

    def classname(page)
      # :use is the required class name
      return page[:use].capitalize if page.has_key?(:use)
      #TODO: test for Pages::ROOT as a special case
      # generate class name from the path
      if not page.has_key?(:path)
        raise ArgumentError.new, "[SiteEngine.classname] invalid page data, has no :path key"
      end
      
      page[:path].split('/').collect {|item| item.capitalize} .join('')    
    end
  end
end