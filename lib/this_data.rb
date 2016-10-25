require "httparty"
require "logger"
require "json"

require "this_data/event"
require "this_data/version"
require "this_data/verbs"
require "this_data/client"
require "this_data/configuration"
require "this_data/track_request"
require "util/nested_struct"

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

    # Tracks a user initiated event which has occurred within your app, e.g.
    # a user logging in.
    #
    # Performs asynchronously if ThisData.configuration.async is true.
    #
    # Parameters:
    # - event       (Required: Hash) a Hash containing details about the event.
    #               See http://help.thisdata.com/v1.0/docs/apiv1events for a
    #               full & current list of available options.
    def track(event)
      if ThisData.configuration.async
        track_async(event)
      else
        track_with_response(event)
      end
    end

    # Verify asks ThisData's API "is this request really from this user?",
    # and returns a response with a risk score.
    #
    # Note: this method does not perform error handling.
    #
    # Parameters:
    # - params      (Required: Hash) a Hash containing details about the current
    #               request & user.
    #               See http://help.thisdata.com/docs/apiv1verify for a
    #               full & current list of available options.
    #
    # Returns a Hash
    def verify(params)
      response = Client.new.post(
        '/verify',
        body: JSON.generate(params)
      )
      response.parsed_response
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

    private

      # Creates a Client and tracks an event.
      # Event must be a Hash.
      # Rescues and logs all exceptions.
      # Returns an HTTPResponse
      def track_with_response(event)
        response = Client.new.track(event)
        success = response && response.success? # HTTParty doesn't like `.try`
        if success
          log("Tracked event! #{response.response.inspect}")
        else
          warn("Track failure! #{response.response.inspect} #{response.body}")
        end
        response
      rescue => e
        ThisData.error("Failed to track event:")
        ThisData.error(e)
        e.backtrace.each do |line|
          ThisData.error(line, prefix: false)
        end
        false
      end

      # Performs the track function within a new Thread, so it is non blocking.
      # Returns the Thread created
      def track_async(event)
        Thread.new do
          track_with_response(event)
        end
      rescue => e
        ThisData.error("Cannot create Thread: #{e.inspect}")
        false
      end

  end
end
