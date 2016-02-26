module ThisData
  class InstallGenerator < Rails::Generators::Base

    argument :api_key

    desc "This generator creates a configuration file for the ThisData ruby client inside config/initializers"
    def create_configuration_file
      initializer "this_data.rb" do
        <<-EOS
# Specifies configuration options for the ThisData gem.
ThisData.setup do |config|

  # This is where your API key goes. You should almost certainly not have it
  # committed to source control, but instead load it from a secret store.
  # Default: nil
  config.api_key = "#{api_key}"

  # Define a Logger instance if you want to debug or track errors
  # This tells ThisData to log in the development environment.
  # Comment it out to use the default behaviour across all environments.
  # Default: nil
  config.logger = Rails.logger if Rails.env.development?

  # When true, will perform track events asynchronously.
  # It is true by default, but here we explicitly tell ThisData to make it
  # synchronous in test and development mode, to aide getting started.
  # Comment it out to use the default behaviour across all environments.
  # Default: true
  config.async  = !(Rails.env.test? || Rails.env.development?)


  # These configuration options are used when for the TrackRequest module.

  # user_method will be called on a controller to get a user object.
  # Default: :current_user
  # config.user_method =        :current_user

  # The following methods will be called on the object returned by user_method,
  # to capture details about the user

  # Required. This method should return a unique ID for a user.
  # Default: :id
  # config.user_id_method =     :id

  # Optional. This method should return the user's name.
  # Default: :name
  # config.user_name_method =   :name
  # This method should return the user's email.
  # Default: :email
  # config.user_email_method =  :email
  # This method should return the user's mobile phone number.
  # Default: :mobile
  # config.user_mobile_method = :mobile

end
EOS
      end
    end
  end
end
