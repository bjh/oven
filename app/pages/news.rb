

class News < Oven::PageBase
  def initialize(page_data)
    super(page_data)
  end
  
  def generate
    begin
      process
    rescue => e
      L::error("News.generate: #{e}")
      #L::error(e.backtrace.join("\n"))
    end
  end
  
private
  def process
    files = []
    
    g = Oven::Generator.create('names')
    g.run do |content|
      name = Oven::Path.safe(content.name)
      files << AppConfig.root_path_plus(@options[:path], name, '/')
    end
    
    articles = []
    g = Oven::Generator.create('news-item')
    g.run do |content|
      articles << content
    end
    
    # create each article page
    (0...files.size).each do |n|
      L::info(files[n])
      L::info(articles[n])
    end
    
    # create the section index page with links to the articles
    (0...files.size).each do |n|
      L::info(files[n])
    end
    
  end
end