module ThisData
  # For the ThisData REST APIv1
  # http://help.thisdata.com/docs/apiv1events
  class Client

    USER_AGENT = "ThisData Ruby v#{ThisData::VERSION}"
    NO_API_KEY_MESSAGE  = "[ThisData] Oops: you've got no API Key configured, so we can't send events. Specify your ThisData API key using ThisData#setup (find yours at https://thisdata.com)"

    include HTTParty

    base_uri "https://api.thisdata.com/v1/"

    def initialize
      @api_key = require_api_key
      @headers = {
        "User-Agent" => USER_AGENT
      }
    end

    def require_api_key
      ThisData.configuration.api_key || print_api_key_warning
    end

    def track(event)
      post_event(event)
    end

    private

      def version
        ThisData.configuration.version
      end

      def post_event(payload_hash)
        path_with_key = "/events?api_key=#{ThisData.configuration.api_key}"
        self.class.post(path_with_key, headers: @headers, body: JSON.generate(payload_hash))
      rescue => e
        ThisData.warn("ThisData failed to post event!")
        ThisData.warn(e)
      end

      def print_api_key_warning
        $stderr.puts(NO_API_KEY_MESSAGE)
      end

  end
end
