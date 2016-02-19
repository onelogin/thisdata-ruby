require_relative "../test_helper.rb"

class ThisData::ConfigurationTest < ThisData::UnitTest

  def setup
    ThisData.setup do |config|
      config.api_key = "abc-123"
    end
  end

  def test_setting_api_key
    assert_equal "abc-123", ThisData.configuration.api_key
  end

  def test_hash_style_access
    assert_equal "abc-123", ThisData.configuration[:api_key]
  end

  def test_default_user_methods
    assert_equal :current_user, ThisData.configuration.user_method
    assert_equal :id,     ThisData.configuration.user_id_method
    assert_equal :name,   ThisData.configuration.user_name_method
    assert_equal :email,  ThisData.configuration.user_email_method
    assert_equal :mobile, ThisData.configuration.user_mobile_method
  end

end
