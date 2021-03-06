
# this just renders out a static page i.e. not data binding
class Static < Oven::PageBase
  def initialize(page_data)
    super(page_data)
  end
  
  def generate
    template = Oven::Template::get(@options[:template])
    body(template.result(Oven::Template::bind(@options).get_binding()))
    write()
  end
end