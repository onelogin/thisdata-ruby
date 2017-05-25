require_relative "../test_helper.rb"

class ThisData::RuleTest < ThisData::UnitTest

  test "can get all rules" do
    response = [
      {
        id: "123456",
        name: "A ruby rule",
        description: "A basic rule",
        type: "blacklist",
        target: "location.ip",
        filters: ["6.6.6.6","7.7.7.7"]
      },
      {
        id: "123456789",
        name: "A second ruby rule",
        description: "A basic rule",
        type: "blacklist",
        target: "location.ip",
        filters: ["1.1.1.1"]
      }      
    ]
    expected_path = URI.encode("https://api.thisdata.com/v1/rules?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:get, expected_path, status: 200, body: response.to_json, content_type: "application/json")

    rules = ThisData::Rule.all

    assert_equal 2,      rules.length
    assert_equal "123456",    rules.first.id
  end

  test "can get a single rule" do
    response = {
      id: "123456",
      name: "A ruby rule",
      description: "A basic rule",
      type: "blacklist",
      target: "location.ip",
      filters: ["6.6.6.6","7.7.7.7"]
    }

    expected_path = URI.encode("https://api.thisdata.com/v1/rules/123456?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:get, expected_path, status: 200, body: response.to_json, content_type: "application/json")

    rule = ThisData::Rule.find(123456)

    assert_equal "123456",    rule.id
  end

  test "can create a rule" do
    response = {
      id: "123456",
      name: "A ruby rule",
      description: "A basic rule",
      type: "blacklist",
      target: "location.ip",
      filters: ["6.6.6.6","7.7.7.7"]
    }

    expected_path = URI.encode("https://api.thisdata.com/v1/rules?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:post, expected_path, status: 201, body: response.to_json, content_type: "application/json")

    rule = ThisData::Rule.create({
      name: "A ruby rule",
      description: "A basic rule",
      type: "blacklist",
      target: "location.ip",
      filters: ["6.6.6.6","7.7.7.7"]
    })

    assert_equal "123456", rule.id
  end

  test "can update a rule" do
    response = {
      id: "123456",
      name: "An updated ruby rule",
      description: "A basic rule",
      type: "blacklist",
      target: "location.ip",
      filters: ["6.6.6.6","7.7.7.7"]
    }

    expected_path = URI.encode("https://api.thisdata.com/v1/rules/123456?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:post, expected_path, status: 200, body: response.to_json, content_type: "application/json")

    rule = ThisData::Rule.update({
      id: "123456",
      name: "An updated ruby rule"
    })

    assert_equal "123456", rule.id
    assert_equal "An updated ruby rule", rule.name
  end

  test "can delete a rule" do
    expected_path = URI.encode("https://api.thisdata.com/v1/rules/123456?api_key=#{ThisData.configuration.api_key}")
    FakeWeb.register_uri(:delete, expected_path, status: 204, content_type: "application/json")

    deleted = ThisData::Rule.destroy(123456)

    assert_equal true, deleted
  end

end