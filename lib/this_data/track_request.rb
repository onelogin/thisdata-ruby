# Include ThisData::TrackRequest in your ApplicationController to get a handy
# track method which looks at the request and current_user variables to
# generate an event.
#
# If you include this in a non-ActionController instance, you must respond to
# `request` and `ThisData.configuration.user_method`
#
module ThisData
  module TrackRequest
    class ThisDataTrackError < StandardError; end

    # Will pull request and user details from the controller, and send an event
    # to ThisData.
    # Arguments:
    #   verb: (String, Required). Defaults to ThisData::Verbs::LOG_IN.
    #   user: (Object, Optional). If you want to override the user record
    #     that we would usually fetch, you can pass it here.
    #     Unless a user is specified here we'll attempt to get the user record
    #       as specified in the ThisData gem configuration. This defaults to
    #       `current_user`.
    #     The object must respond to at least
    #       `ThisData.configuration.user_id_method`, which defaults to `id`.
    #
    # Returns the result of ThisData.track (an HTTPartyResponse)
    def thisdata_track(verb: ThisData::Verbs::LOG_IN, user: nil)
      if user.nil?
        user = send(ThisData.configuration.user_method)
      end

      event = {
        verb:       verb,
        ip:         request.remote_ip,
        user_agent: request.user_agent,
        user:       user_details(user)
      }

      # If we expect there to be a cookie configured, send it it along.
      # If the cookie is nil, the user likely has an ad-blocker, but that's
      # fine too.
      if ThisData.configuration.expect_js_cookie
        cookie_value = cookies[ThisData::Configuration::JS_COOKIE_NAME] rescue nil

        event[:other] ||= {}
        event[:other][:td_cookie_id] = cookie_value
      end

      ThisData.track(event)
    rescue => e
      ThisData.error "Could not track event:"
      ThisData.error e
      ThisData.error e.backtrace[0..5].join("\n")
      false
    end

    private

      # Will return a Hash of details for a user using the methods specified
      # in the gem configuration.
      # Will raise a NoMethodError if user does not respond the
      # specified `user_id_method`. A user id is required for all events.
      def user_details(user)
        {
          id:     user.send(ThisData.configuration.user_id_method),
          name:   value_if_configured(user, "user_name_method"),
          email:  value_if_configured(user, "user_email_method"),
          mobile: value_if_configured(user, "user_mobile_method"),
        }
      end

      # Will return the result of calling a method defined in ThisData's config
      # if the object responds to that method.
      def value_if_configured(object, config_option)
        method = ThisData.configuration.send("#{config_option}")
        if object.respond_to?(method, true)
          return object.send(method)
        else
          nil
        end
      end

  end
end