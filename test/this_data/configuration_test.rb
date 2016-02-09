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

end
