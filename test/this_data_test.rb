require_relative "test_helper.rb"

class ThisDataTest < ThisData::UnitTest

  test "track will use track_async when config option is true" do
    event = stub()
    thread = stub()
    ThisData.expects(:track_async).with(event, {}).returns(thread)

    ThisData.configuration.async = true
    assert_equal thread, ThisData.track(event)
  end

  test "track will use track_with_response when config option is false" do
    event = stub()
    http_response = stub()
    ThisData.expects(:track_with_response).with(event, {}).returns(http_response)

    ThisData.configuration.async = false
    assert_equal http_response, ThisData.track(event)
  end

  test "track_with_response creates client and uses track" do
    client = stub()
    ThisData::Client.expects(:new).returns(client)
    event = stub()
    response = stub("success?" => true, response: stub())
    client.expects(:track).with(event, {}).returns(response)
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

  test "successful track is logged" do
    path = URI.encode("https://api.thisdata.com/v1/events?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:post, path, body: "foo", status: 201)

    ThisData.expects(:log).with("Tracked event! #<Net::HTTPCreated 201  readbody=true>")
    ThisData.send(:track_with_response,
      ip: "1.2.3.4",
      user: {id: "the-users-uuid"}
    )
  end

  test "unsuccessful track_with_response is logged" do
    path = URI.encode("https://api.thisdata.com/v1/events?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:post, path, body: '{"error": "message"}', status: 400)

    ThisData.expects(:warn).with('Track failure! #<Net::HTTPBadRequest 400  readbody=true> {"error": "message"}')
    ThisData.send(:track_with_response,
      ip: "1.2.3.4",
      user: {id: "the-users-uuid"}
    )
  end


  test "verify creates client and uses post" do
    client = stub()
    ThisData::Client.expects(:new).returns(client)
    response = stub("success?" => true, parsed_response: {})
    params = {foo: "bar"}
    client.expects(:post).with('/verify', {body: params.to_json, query:{}}).returns(response)
    assert ThisData.send(:verify, params)
  end

  test "verify parses JSON response" do
    response = {
      score: 0.123,
      risk_level: "green"
    }
    expected_path = URI.encode("https://api.thisdata.com/v1/verify?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:post, expected_path, status: 200, body: response.to_json, content_type: "application/json")
    result = ThisData.send(:verify, {})
    assert_equal 0.123, result["score"]
  end

end