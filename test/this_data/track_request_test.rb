require_relative "../test_helper.rb"

class FakeController
  include ThisData::TrackRequest

  # These are methods we expect to be able to call when TrackRequest is
  # included
  attr_accessor :request
  attr_accessor :current_user
  # And this is to test that changing method names works
  attr_accessor :foo_user
end

class ThisData::TrackRequestTest < ThisData::UnitTest

  def setup
    super
    register_successful_events
    @controller = FakeController.new
    @controller.request = stub(remote_ip: nil, user_agent: nil)
  end

  test "user_details returns a Hash of user detail" do
    user = stub(id: "12345")
    expected = {
      id: "12345",
      name: nil,
      email: nil,
      mobile: nil
    }
    assert_equal expected, @controller.send(:user_details, user)
  end

  test "user_details can return lots of user details" do
    user = stub(id: "12345", email: "foo@bar.com", mobile: "+1234", name: "Foo Bar")
    expected = {
      id: "12345",
      name: "Foo Bar",
      email: "foo@bar.com",
      mobile: "+1234"
    }
    assert_equal expected, @controller.send(:user_details, user)
  end

  test "thisdata_track will fetch a user from user_method" do
    user = stub(id: "12345")
    @controller.current_user = user
    @controller.expects(:user_details).with(user)
    @controller.send(:thisdata_track)
  end

  test "thisdata_track can use a different user, from overridden user_method" do
    user1 = stub(id: "12345")
    user2 = stub(id: "67890")
    @controller.current_user = user1
    @controller.foo_user = user2

    @controller.expects(:user_details).with(user2)

    # Override the default `user_method`
    ThisData.configuration.user_method = :foo_user
    @controller.send(:thisdata_track)
  end

  test "thisdata_track accepts an explicit user instance" do
    failed_login_user = stub(id: "12345")
    @controller.expects(:user_details).with(failed_login_user)
    @controller.send(:thisdata_track, user: failed_login_user)
  end

  test "thisdata_track creates and posts an event containing user and request details" do
    request = stub(remote_ip: "1.2.3.4", user_agent: "Chrome User Agent")
    @controller.request = request

    user = stub(id: "12345", email: "foo@bar.com", mobile: "+1234", name: "Foo Bar")
    @controller.current_user = user

    expected = {
      ip: "1.2.3.4",
      user_agent: "Chrome User Agent",
      verb: "log-in",
      user: {
        id: "12345",
        name: "Foo Bar",
        email: "foo@bar.com",
        mobile: "+1234"
      }
    }

    ThisData.expects(:track).with(expected).once
    @controller.thisdata_track
  end

  test "thisdata_track creates and posts an event containing user and request details" do
    ThisData.expects(:track).with(has_key(verb: 'foo')).once
    @controller.thisdata_track(verb: 'foo')
  end

  test "thisdata_track creates and posts an event containing user and request details" do
    request = stub(remote_ip: "1.2.3.4", user_agent: "Chrome User Agent")
    @controller.request = request

    user = stub(id: "12345", email: "foo@bar.com", mobile: "+1234", name: "Foo Bar")
    @controller.current_user = user

    expected = {
      ip: "1.2.3.4",
      user_agent: "Chrome User Agent",
      verb: "log-in",
      user: {
        id: "12345",
        name: "Foo Bar",
        email: "foo@bar.com",
        mobile: "+1234"
      }
    }

    ThisData.expects(:track).with(expected).once
    @controller.thisdata_track
  end

  test "thisdata_track will silently handle errors" do
    ThisData.stubs(:track).raises(ArgumentError)
    assert_equal false, @controller.thisdata_track
  end
end
