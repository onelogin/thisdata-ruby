require_relative "../test_helper.rb"

class ThisData::ConfigurationTest < ThisData::UnitTest

  def setup
    ThisData.setup do |config|
      config.api_key = "abc-123"
    end
  end

  test "setting api key" do
    assert_equal "abc-123", ThisData.configuration.api_key
  end

  test "hash style access" do
    assert_equal "abc-123", ThisData.configuration[:api_key]
  end

  test "default user methods" do
    assert_equal :current_user, ThisData.configuration.user_method
    assert_equal :id,     ThisData.configuration.user_id_method
    assert_equal :name,   ThisData.configuration.user_name_method
    assert_equal :email,  ThisData.configuration.user_email_method
    assert_equal :mobile, ThisData.configuration.user_mobile_method
  end

  test "asynchronous by default" do
    assert ThisData.configuration.async
  end

end
