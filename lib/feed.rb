
module Oven
  class Feed
    def initialize(url, selector)
      #puts "FEED(#{url}, #{selector})"
      @url = url
      @selector = selector
      @xml = nil
    end
  
    def consume(&block)
      if not block_given?
        raise "no block given to Feed.consume()"
      end
    
      read() if @xml.nil?    
    
      @xml.xpath(@selector).each do |node|
        block.call(node)
      end
    end
  
    def select(selector)
      read() if @xml.nil?
    
      if selector
        @xml.xpath(selector) 
      else
        @xml.xpath(@selector)
      end
    end
  
  private
    def read
      begin
        timeout(5) do
           @xml = Nokogiri::XML(open(@url))
        end
      rescue Timeout::Error, OpenURI::HTTPError => e
        L::error("Feed.read:timeout => #{e}")
        @xml = nil
      rescue => e
        L::error("Feed.read => #{e}")
        @xml = nil
      end
    end
  end
end