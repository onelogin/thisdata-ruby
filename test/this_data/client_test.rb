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

end