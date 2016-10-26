# Include ThisData::TrackRequest in your ApplicationController to get a handy
# track method which looks at the request and current_user variables to
# generate an event.
#
# This module will also provide access to the verify API.
#
# If you include this in a non-ActionController instance, you must respond to
# `request` and `ThisData.configuration.user_method`
#
module ThisData
  module TrackRequest
    class ThisDataTrackError < StandardError; end
    class NoUserSpecifiedError < ArgumentError; end

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
    #   authenticated: (Boolean, Optional, default nil). Used to indicate
    #     whether a user is authenticated or not. By default we assume that if
    #     there is a user specified then they are authenticated, but in some
    #     cases (like a log-in-denied event) you might want to track the user
    #     but tell us that they are not authenticated.
    #     In these situations you should set `authenticated` to false.
    #
    # Returns the result of ThisData.track (an HTTPartyResponse)
    def thisdata_track(verb: ThisData::Verbs::LOG_IN, user: nil, authenticated: nil)
      # Fetch the user unless it's been overridden
      if user.nil?
        user = send(ThisData.configuration.user_method)
      end

      # Get a Hash of details for the user
      user_details = user_details(user)

      # If specified, set the authenticated state of the user
      unless authenticated.nil?
        user_details.merge!(authenticated: authenticated)
      end

      event = {
        verb:       verb,
        ip:         request.remote_ip,
        user_agent: request.user_agent,
        user:       user_details,
        session: {
          td_cookie_expected: ThisData.configuration.expect_js_cookie,
          td_cookie_id:       td_cookie_value,
        }
      }

      ThisData.track(event)
    rescue => e
      ThisData.error "Could not track event:"
      ThisData.error e
      ThisData.error e.backtrace[0..5].join("\n")
      false
    end

    # Will pull request and user details from the controller, and use
    # ThisData's verify API to determine how likely it is that the person who
    # is currently logged in has had their account compromised.
    #
    # Arguments:
    #   user: (Object, Required). If you want to override the user record
    #     that we would usually fetch, you can pass it here.
    #     Unless a user is specified here we'll attempt to get the user record
    #       as specified in the ThisData gem configuration. This defaults to
    #       `current_user`.
    #     The object must respond to at least
    #       `ThisData.configuration.user_id_method`, which defaults to `id`.
    #
    #
    # Returns a Hash with risk information.
    # See http://help.thisdata.com/docs/apiv1verify for details
    def thisdata_verify(user: nil)
      # Fetch the user unless it's been overridden
      if user.nil?
        user = send(ThisData.configuration.user_method)
      end
      # If it's still nil, raise an error
      raise NoUserSpecifiedError, "A user must be provided for verification" if user.nil?

      # Get a Hash of details for the user
      user_details = user_details(user)

      event = {
        ip:         request.remote_ip,
        user_agent: request.user_agent,
        user:       user_details,
        session: {
          td_cookie_expected: ThisData.configuration.expect_js_cookie,
          td_cookie_id:       td_cookie_value,
        }
      }

      ThisData.verify(event)
    rescue => e
      ThisData.error "Could not verify current user:"
      ThisData.error e
      ThisData.error e.backtrace[0..5].join("\n")
      nil
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

      # When using the optional JavaScript library, a cookie is placed which
      # helps us track devices.
      # If the cookie is nil, then either you aren't using the JS library, or
      # the user likely has an ad-blocker.
      def td_cookie_value
        cookies[ThisData::Configuration::JS_COOKIE_NAME] rescue nil
      end

  end
end