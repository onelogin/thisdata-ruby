# Include ThisData::TrackRequest in your ApplicationController to get a handy
# track method which looks at the request and current_user variables to
# generate an event.
module ThisData
  module TrackRequest

    def td_track(verb: ThisData::Verbs::LOG_IN)
      controller = env["action_controller.instance"]
      if controller
        if controller.respond_to?(ThisData.configuration.user_method, true)
          user = controller.send(ThisData.configuration.user_method)

          event = {
            ip: request.remote_ip,
            verb: verb,
            user_agent: request.user_agent,
            user: {
              id:     user.send(ThisData.configuration.user_id_method),
              name:   value_if_configured(user, "user_name_method"),
              email:  value_if_configured(user, "user_email_method"),
              mobile: value_if_configured(user, "user_mobile_method"),
            }
          }

          ThisData.track(event)

        else
          Rails.logger.warn "[ThisData] could not get user using ThisData.configuration.user_method"
        end
      else
        Rails.logger.warn "[ThisData] could not get controller instance"
      end
    end

    private
      def value_if_configured(object, config_option)
        method = ThisData.configuration.send("#{config_option}")
        if object.respond_to?(method, true)
          object.send(method)
        end
      end

  end
end