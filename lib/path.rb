module Oven
  module Path
    def self.slash(path)
      # condense two or more /'s into one
      path.gsub(/[\/]{2,}/, '/')
    end
  
    def self.create(path)
      %x{mkdir -p #{path}}
    end
  
    def self.safe(path)
      # remove any illegal characters for a filename
      p = path.to_s.strip.gsub(/[^a-zA-Z0-9\s\.]/, '')
      # reduce multiple sequential whitespace characters into one space
      p = p.gsub(/\s{2,}/, ' ')
      # whitespace to hyphen
      p = p.gsub(/\s/, '-')
      p.downcase
    end
  end
end