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

    def track(event)
      log("[ThisData] Tracking Event...")
      Client.new.track(event)
    end

    def log(message)
      configuration.logger.info(message) if configuration.logger
    end

  end
end
