module ThisData
  class InstallGenerator < Rails::Generators::Base

    argument :api_key

    desc "This generator creates a configuration file for the ThisData ruby client inside config/initializers"
    def create_configuration_file
      initializer "this_data.rb" do
        <<-EOS
ThisData.setup do |config|
  config.api_key = "#{api_key}"
end
EOS
      end
    end
  end
end
