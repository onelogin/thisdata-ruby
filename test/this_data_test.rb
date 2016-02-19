require_relative "test_helper.rb"

class ThisDataTest < ThisData::UnitTest

  def test_track_creates_client_and_uses_track
    client = stub()
    ThisData::Client.expects(:new).returns(client)
    event = stub()
    client.expects(:track).with(event)
    ThisData.track(event)
  end

  def test_track_login
    expected = {
      verb: ThisData::Verbs::LOG_IN,
      ip: "1.2.3.4",
      user: {
        id: "the-users-uuid"
      },
      user_agent: nil
    }
    ThisData.expects(:track).with(expected)
    ThisData.track_login(
      ip: "1.2.3.4",
      user: {id: "the-users-uuid"}
    )
  end

end