module ThisData
  class InstallGenerator < Rails::Generators::Base

    argument :api_key

    desc "This generator creates a configuration file for the ThisData ruby client inside config/initializers"
    def create_configuration_file
      initializer "this_data.rb" do
        <<-EOS
ThisData.setup do |config|
  config.api_key = "#{api_key}"

  # config.user_method =        :current_user
  # config.user_id_method =     :id
  # config.user_name_method =   :name
  # config.user_email_method =  :email
  # config.user_mobile_method = :mobile
end
EOS
      end
    end
  end
end
