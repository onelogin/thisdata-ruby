$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'this_data'

require 'minitest/autorun'
require 'mocha/mini_test'
require 'fakeweb'

class ThisData::UnitTest < Minitest::Test
  def setup
    FakeWeb.allow_net_connect = false
    ThisData.configuration.api_key = "test api key"
  end

  def register_successful_events
    successful_path = "https://api.thisdata.com/v1/events?api_key=#{ThisData.configuration.api_key}"
    FakeWeb.register_uri(:post, successful_path, body: "", status: 202)
  end

  def teardown
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
    reset_configuration
  end

  def reset_configuration
    ThisData.configuration = ThisData::Configuration.new
  end

  # Add declarative test methods, a la rails
  #   test "foo bar" do
  #     # test goes here
  #   end
  class << self # The def self.test way of doing it doesn't override Kernel.test but this does...
    def test(name, &block)
      method_name = "test_#{ name.gsub(/[\W]/, '_') }"
      if block.nil?
        define_method(method_name) do
          flunk "Missing implementation for test #{name.inspect}"
        end
      else
        define_method(method_name, &block)
      end
    end
  end
end