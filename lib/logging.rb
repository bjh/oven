
require 'logger'

module Oven
  class Logging
    def self.create()
      logger = Logger.new(STDOUT)
      logger::formatter = proc do |severity, datetime, progname, msg|
        message = "[#{severity.downcase}] #{msg}\n"
                
        # :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default
        case severity.downcase.to_sym
        when :error
          message.color(:red)
        when :warn
          message.color(:yellow)
        when :debug
          message.color(:green)
        when :info
          message.color(:blue)
        else
          message.color(:defalt)
        end
      end
      logger
    end
  end
end
