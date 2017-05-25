module ThisData
  # For the ThisData REST APIv1
  # http://help.thisdata.com/docs/apiv1events
  class Client

    USER_AGENT = "ThisData Ruby v#{ThisData::VERSION}"
    NO_API_KEY_MESSAGE  = "Oops: you've got no ThisData API Key configured, so we can't talk to the API. Specify your ThisData API key using ThisData#setup (find yours at https://thisdata.com)"

    include HTTParty

    base_uri "https://api.thisdata.com/v1/"

    def initialize
      @api_key = require_api_key
      @headers = {
        "User-Agent" => USER_AGENT
      }
      @default_query = {
        api_key: ThisData.configuration.api_key
      }
    end

    def require_api_key
      ThisData.configuration.api_key || print_api_key_warning
    end

    # A convenience method for tracking Events.
    #
    # Parameters:
    # - event       (Required: Hash) a Hash containing details about the event.
    #               See http://help.thisdata.com/v1.0/docs/apiv1events for a
    #               full & current list of available options.
    def track(event)
      post(ThisData::EVENTS_ENDPOINT, body: JSON.generate(event))
    end

    # Perform a GET request against the ThisData API, with the API key
    # prepopulated
    def get(path, query: {})
      query = @default_query.merge(query)
      self.class.get(path, query: query, headers: @headers)
    end

    # Perform a POST request against the ThisData API, with the API key
    # prepopulated
    def post(path, query: {}, body: {})
      query = @default_query.merge(query)
      self.class.post(path, query: query, headers: @headers, body: body)
    end

    # Perform a DELETE request against the ThisData API, with the API key
    # prepopulated
    def delete(path)
      self.class.delete(path, query: @default_query, headers: @headers)
    end

    private

      def version
        ThisData.configuration.version
      end

      def print_api_key_warning
        $stderr.puts(NO_API_KEY_MESSAGE)
      end

  end
end
