

module Oven
  class ItemStore
    def initialize
      @store = {}
    end

    def get(key)
      # return the item in the store or just pass through the key
      if @store.has_key?(key.to_sym)
        return @store[key.to_sym]
      else
        L::warn("ItemStore.get(#{key}) not found, passing through key")
        return key
      end
    end

    def put(key, value)
      @store[key.to_sym] = value
    end

    def inherit(name, inherits_from, items)
      
      item = get(inherits_from)
      
      if item == inherits_from
        raise TypeError.new, "ItemStore.inherit, need to inherit from a Hash"
      end
      
      put(name, item.merge(items))
    end
    
    # expects a hash of items
    def merge(items)
      #puts "ItemStore.merge(#{items})"
      if not items.is_a?(Hash)
        raise TypeError.new, "trying to merge something that is NOT a Hash"
      end
      
      items.each do |k, v|
        put(k, v)
      end      
    end

    def to_s
      output = []
      @store.each_pair do |k, v|
        output << "#{k} #{v}"
      end
      output.join("\n")
    end
  end
end