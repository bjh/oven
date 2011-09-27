# things everybody needs, sort of like food and water...

# load all files in the lib folder
Dir["#{AppConfig[:approot]}lib/*.rb"].each do |file| 
  require file if file !~ /includes/
end

# load all the page classes
Dir["#{AppConfig[:approot]}app/pages/*.rb"].each do |file| 
  require file
end

# rubytree.rubyforge.org
require 'tree'
require 'erb'
require 'ostruct'
require 'timeout'
require 'open-uri'
require 'nokogiri'
require 'rainbow'
Sickill::Rainbow.enabled = true
