# set up the load paths
['config', 'lib', 'app'].each do |path|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), path))
end

require 'config'
require '_includes'

L = Oven::Logging::create()

class Main
  def self.parse(arguments)
    if File.exists?(AppConfig[:structure])
      structure = Oven::Pages.new(AppConfig[:structure])
      
      Oven::SiteEngine.new(structure.tree).generate()      
    else
      L::error("structure file not found [#{AppConfig[:structure]}]")
    end
  end
end

Main::parse(ARGV)
