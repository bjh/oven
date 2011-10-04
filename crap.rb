# 
# 
# a = {
#   :use => 'use A',
#   :fake => 'A'
# }
# 
# b = {
#   :use => 'use B',
#   :magic => true,
#   #:fake => 'B'
# }
# 
# 
# puts "a.merge(b) = " + a.merge(b).inspect
# puts "b.merge(a) = " + b.merge(a).inspect

def inherit_rules(existing, incoming)
  # the first element is the name of the rule
  rules = existing
  
  (0...rules.size).each do |n|
    puts "rule" + rules[n].first.inspect
    
    overwrite = incoming.select do |incoming_rule|
      # is there a matching rule to overwrite?
      incoming_rule[0] == rules[n].first
    end
    
    if not overwrite.empty?
      rules[n] = overwrite.first
    end
  end
  rules
end

first = [[:name, 'name/text()'], [:drawdate, 'drawDate/text()']]
second = [[:name, 'name/text()', :filter], [:onerous, 'balls/cake/text()']]

puts "BEFORE: #{first.inspect}"
after =  sexy(first, second)
puts "AFTER: #{after.inspect}"
