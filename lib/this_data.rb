require "httparty"
require "logger"
require "json"

require "this_data/version"
require "this_data/verbs"
require "this_data/client"
require "this_data/configuration"

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
    def track(event)
      log("[ThisData] Tracking Event...")
      Client.new.track(event)
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

    def log(message)
      configuration.logger.info(message) if configuration.logger
    end
    def warn(message)
      configuration.logger.warn(message) if configuration.logger
    end

  end
end
