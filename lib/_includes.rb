
puts '-' * 34
puts "AppConfig[:approot]: #{AppConfig[:approot]}"

# things everybody needs, sort of like food and water...

# load all files in the lib folder
Dir["#{AppConfig[:approot]}lib/*.rb"].each do |file|
  require file if file !~ /includes/
end

# load all the page classes
Dir["#{AppConfig[:approot]}app/pages/*.rb"].each do |file| 
  puts "pages: #{file}"
  require file
end

# load all the filters
Dir["#{AppConfig[:approot]}app/filters/*.rb"].each do |file|
  puts "filters: #{file}"
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
require 'bruce-banner'

Sickill::Rainbow.enabled = true
