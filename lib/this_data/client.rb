module ThisData
  # For the ThisData REST APIv1
  # http://help.thisdata.com/docs/apiv1events
  class Client

    USER_AGENT = "ThisData Ruby v#{ThisData::VERSION}"
    NO_API_KEY_MESSAGE  = "Oops: you've got no ThisData API Key configured, so we can't send events. Specify your ThisData API key using ThisData#setup (find yours at https://thisdata.com)"

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

    # Tracks a user initiated event which has occurred within your app, e.g.
    # a user logging in.
    # See http://help.thisdata.com/v1.0/docs/apiv1events for more information.
    # - event       (Required: Hash) the event, containing the following keys:
    #  - verb       (Required: String) 'what' the user did, e.g. 'log-in'.
    #                 See ThisData::Verbs for predefined options.
    #  - ip         (Required: String) the IP address of the request
    #  - user_agent (Optional: String) the user agent from the request
    #  - user       (Required: Hash)
    #   - id        (Required: String)  a unique identifier for this User
    #   - email     (Optional*: String) the user's email address.
    #   - mobile    (Optional*: String) a mobile phone number in E.164 format
    #                 *email and/or mobile MUST be passed if you want ThisData
    #                 to send 'Was This You?' notifications via email and/or SMS
    #   - name      (Optional: String)  the user's name, used in notifications
    #  - session   (Optional: Hash) details about the user's session
    #   - td_cookie_expected (Optional: Boolean) whether you expect a JS cookie
    #                         to be present
    #   - td_cookie_id       (Optional: String) the value of the JS cookie
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
      end

      def print_api_key_warning
        $stderr.puts(NO_API_KEY_MESSAGE)
      end

  end
end
