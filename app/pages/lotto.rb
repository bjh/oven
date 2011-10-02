
class Lotto < Oven::PageBase
  # mixin the Process.run() function
  include Process
  
  def initialize(page_data)
    super(page_data)
  end
  
  def generate
    begin
      #run(name_generator, item_generator, article_template)
      run('lotto-names', 'lotto-items', 'news-item')
    rescue => e
      L::error("Lotto.generate: #{e}")
      #L::error(e.backtrace.join("\n"))
    end
  end
end