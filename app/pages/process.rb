

# should be mixed in to any pages thatuse the same logic
module Process
  def run(name_generator, item_generator, article_template)
    files = []
    names = []
    
    Oven::Generator.create(name_generator).run do |content|
      name = Oven::Path.safe(content.name)
      files << Oven::Path.slash([@options[:path], name, '/'].join('/'))
      names << name
    end
    
    articles = []
    Oven::Generator.create(item_generator).run do |content|
      articles << content
    end
    
    # create each article page
    (0...files.size).each do |n|
      article_path = files[n]
      article_content = articles[n]
      
      article = Article.new(
        :template => article_template,
        :path => article_path,
        # used in the template header
        :name => names[n]
      )
      article.body(article_content)
      article.write()
    end
    
    template = Oven::Template::get(@options[:template])
    body(template.result(binding()))
    write()
  end
end