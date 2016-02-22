require "ostruct"

module ThisData
  class Configuration

    # Programatically create attr accessors for config_option
    def self.config_option(name)
      define_method(name) do
        read_value(name)
      end

      define_method("#{name}=") do |value|
        set_value(name, value)
      end
    end

    # Your ThisData API Key - this can be found on ThisData.com > Integrations
    #   > Login Intelligence API
    config_option :api_key

    # When true, requests will be performed asynchronously. Setting this to
    # false can help with debugging.
    # Default: true
    config_option :async

    # Log the events sent
    config_option :logger

    # TrackRequest config options
    # We will attempt to call this method on a Controller to get the user record
    # Default: :current_user
    config_option :user_method
    # This method should return a unique ID for a user. Default: :id
    config_option :user_id_method
    # This method should return the user's name. Default: :name
    config_option :user_name_method
    # This method should return the user's email. Default: :email
    config_option :user_email_method
    # This method should return the user's mobile phone number. Default: :mobile
    config_option :user_mobile_method

    attr_reader :defaults

    def initialize
      @config_values = {}

      # set default attribute values
      @defaults = OpenStruct.new({
        async:              true,
        user_method:        :current_user,
        user_id_method:     :id,
        user_name_method:   :name,
        user_email_method:  :email,
        user_mobile_method: :mobile
      })
    end

    def [](key)
      read_value(key)
    end

    def []=(key, value)
      set_value(key, value)
    end

    private

      def read_value(name)
        if @config_values.has_key?(name)
          @config_values[name]
        else
          @defaults.send(name)
        end
      end

      def set_value(name, value)
        @config_values[name] = value
      end

  end
end