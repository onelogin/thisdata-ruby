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
    def thisdata_track(verb: ThisData::Verbs::LOG_IN)
      event = {
        verb:       verb,
        ip:         request.remote_ip,
        user_agent: request.user_agent,
        user:       user_details
      }

      ThisData.track(event)
    rescue => e
      ThisData.error "Could not track event:"
      ThisData.error e
      ThisData.error e.backtrace[0..5].join("\n")
      false
    end

    private

      # Will fetch a user and return a Hash of details for the User returned
      # by `ThisData.configuration.user_method`.
      # Will raise a NoMethodError if controller does not return a user,
      #  or we can't get a user id.
      def user_details
        user = send(ThisData.configuration.user_method)
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