require_relative "../test_helper.rb"

class ThisData::ClientTest < ThisData::UnitTest

  def setup
    super
    @client = ThisData::Client.new
    register_successful_events
  end

  def test_api_key_required_message
    ThisData.configuration.api_key = nil

    $stderr.expects(:puts).with(ThisData::Client::NO_API_KEY_MESSAGE).once
    second_client = ThisData::Client.new
  end

  def test_track_event
    event = {
      verb: ThisData::Verbs::LOG_IN,
      ip: "1.2.3.4",
      user_agent: "a browser",
      user: {
        id: "the-users-uuid"
      }
    }
    # POST requests are faked to return 200s in test_helper.rb
    response = @client.track(event)
    assert response.success?
  end

  def test_get_adds_api_key
    @client.class.expects(:get).with('foo', has_entries(
      query: {api_key: "test-api-key"},
      headers: has_key("User-Agent")
    ))
    response = @client.get('foo')
  end

  def test_post_adds_api_key
    @client.class.expects(:post).with('foo', has_entries(
      query: {api_key: "test-api-key"},
      headers: has_key("User-Agent")
    ))
    response = @client.post('foo')
  end

end