

class News < Oven::PageBase
  # mixin the Process.run() function
  include Process
  
  def initialize(page_data)
    super(page_data)
  end
  
  def generate
    begin
      run('names', 'news-item', 'news-item')
    rescue => e
      L::error("News.generate: #{e}")
      #L::error(e.backtrace.join("\n"))
    end
  end
end