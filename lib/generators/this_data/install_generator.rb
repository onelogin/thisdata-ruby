module ThisData
  class InstallGenerator < Rails::Generators::Base

    argument :api_key

    desc "This generator creates a configuration file for the ThisData ruby client inside config/initializers"
    def create_configuration_file
      initializer "this_data.rb" do
        <<-EOS
ThisData.setup do |config|
  config.api_key = "#{api_key}"

  # user_method will be called on a controller when using TrackRequest
  # config.user_method =        :current_user

  # The following methods will be called on the object returned by user_method,
  # to capture details about the user
  # config.user_id_method =     :id
  # config.user_name_method =   :name
  # config.user_email_method =  :email
  # config.user_mobile_method = :mobile

  # Define a Logger instance if you want to debug / track errors
  # config.logger = Rails.logger unless Rails.env.production?

  # Set this to false if you want ThisData.track to perform in the same thread
  # config.async =               false
end
EOS
      end
    end
  end
end
