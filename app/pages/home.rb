
class Home < Oven::PageBase
  def initialize(page_data)
    super(page_data)
  end
  
  def generate
    begin
      puts '-' * 70
      puts "NEWS ITEMs FROM THE STORE"
      puts Oven::StringStore.get('news-item')
      puts "LOTTO ITEMs FROM THE STORE"
      puts Oven::StringStore.get('lotto-items')
      
    rescue => e
      L::error("Home.generate: #{e}")
      #L::error(e.backtrace.join("\n"))
    end
  end
end