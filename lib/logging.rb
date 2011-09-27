
require 'logger'
module Oven
  class Logging
    def self.create()
      logger = Logger.new(STDOUT)
      logger::formatter = proc do |severity, datetime, progname, msg|
        message = "[#{severity.downcase}] #{msg}\n"
        level = severity.downcase.to_sym
        
        # :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default
        case 
        when level == :error
          message.color(:red)
        when level == :warn
          message.color(:yellow)
        when level == :debug
          message.color(:green)
        when level == :info
          message.color(:blue)
        else
          message.color(:defalt)
        end
      end
      logger
    end
  end
end
