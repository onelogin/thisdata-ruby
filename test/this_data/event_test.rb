require_relative "../test_helper.rb"

class ThisData::EventTest < ThisData::UnitTest

  test "can get all events" do
    response = {
      total: 10,
      results: [
        {id: "1", overall_score: 0.5, user: {id: 112233}},
        {id: "2", overall_score: 0.1, user: {id: 445566}}
      ]
    }
    expected_path = URI.encode("https://api.thisdata.com/v1/events?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:get, expected_path, status: 200, body: response.to_json, content_type: "application/json")

    events = ThisData::Event.all

    assert_equal 2,      events.length
    assert_equal "1",    events.first.id
    assert_equal 445566, events.last.user.id
  end

  test "can filter events" do
    expected_query= {
      api_key: ThisData.configuration.api_key,
      user_id: 112233,
      limit: 25,
      foo: "bar"
    }
    response = {total: 0, results: []}
    expected_path = URI.encode("https://api.thisdata.com/v1/events?#{URI.encode_www_form(expected_query)}")
    FakeWeb.register_uri(:get, expected_path, status: 200, body: response.to_json, content_type: "application/json")

    ThisData::Event.all(
      user_id: 112233,
      limit: 25,
      foo: "bar"
    )
  end

end