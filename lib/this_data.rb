require "httparty"
require "logger"
require "json"

require "this_data/version"
require "this_data/verbs"
require "this_data/client"
require "this_data/configuration"
require "this_data/track_request"

module ThisData

  class << self

    # Configuration Object (instance of ThisData::Configuration)
    attr_writer :configuration

    def setup
      yield(configuration)
    end

    def configuration
      @configuration ||= ThisData::Configuration.new
    end

    def default_configuration
      configuration.defaults
    end

    # Creates a Client and tracks an event.
    # Event must be a Hash
    def track(event)
      Client.new.track(event)
      log("Tracked event!")
    rescue => e
      ThisData.error("Failed to track event:")
      ThisData.error(e)
      e.backtrace.each do |line|
        ThisData.error(line, prefix: false)
      end
      false
    end

    # A helper method to track a log-in event. Validates that the minimum
    # required data is present.
    def track_login(ip: '', user: {}, user_agent: nil)
      raise ArgumentError, "IP Address is required" unless ip.length
      raise ArgumentError, "User needs ID value" unless user[:id].to_s.length
      track({
        verb: ThisData::Verbs::LOG_IN,
        ip: ip,
        user_agent: user_agent,
        user: user
      })
    end

    def log(message, level: 'info', prefix: true)
      if prefix
        message = "[ThisData] " + message.to_s
      end
      configuration.logger.send(level, message) if configuration.logger
    end
    def warn(message, prefix: true)
      log(message, level: 'warn', prefix: prefix)
    end
    def error(message, prefix: true)
      log(message, level: 'error', prefix: prefix)
    end

  end
end
