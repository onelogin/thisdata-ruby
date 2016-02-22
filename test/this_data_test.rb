require_relative "test_helper.rb"

class ThisDataTest < ThisData::UnitTest

  test "track will use track_async when config option is true" do
    event = stub()
    thread = stub()
    ThisData.expects(:track_async).with(event).returns(thread)

    assert_equal thread, ThisData.track(event)
  end

  test "track will use track_with_response when config option is false" do
    event = stub()
    http_response = stub()
    ThisData.expects(:track_with_response).with(event).returns(http_response)

    ThisData.configuration.async = false
    assert_equal http_response, ThisData.track(event)
  end

  test "track_with_response creates client and uses track" do
    client = stub()
    ThisData::Client.expects(:new).returns(client)
    event = stub()
    client.expects(:track).with(event)
    ThisData.send(:track_with_response, event)
  end

  test "track_async uses a new thread" do
    Thread.expects(:new)
    ThisData.send(:track_async, stub())
  end

  test "track_login calls track" do
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