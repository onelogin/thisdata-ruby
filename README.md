# ThisData Ruby [![Build Status](https://travis-ci.org/thisdata/thisdata-ruby.png?branch=master)](https://travis-ci.org/thisdata/thisdata-ruby)

This gem allows you to use the ThisData Login Intelligence API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thisdata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thisdata

## Usage

Our API endpoint documentation, tutorials, and sample code can all be found at
http://help.thisdata.com

### Plain Old Ruby

#### Configuration

An example ThisData configuration is below. See `this_data/configuration.rb` for
more options. For example, in production we recommend you turn on
 the asynchronous and non-logging behaviour.

If you're using Rails, you can generate this config file by following our
[Set Up](#set-up) steps further down.


```ruby
require 'this_data'
ThisData.setup do |config|
  config.api_key = 'API_KEY_HERE' # Don't commit your key to source control!
  config.logger  = Logger.new($stdout)
  config.async   = false
end
```

#### Tracking an Event

You can then track any event by calling `ThisData.track` and passing a Hash which
contains an event. In the following example, we're tracking a user logging in
to our app:

```ruby
ThisData.track(
  {
    ip: request.remote_ip,
    user_agent: request.user_agent,
    verb: ThisData::Verbs::LOG_IN,
    user: {
      id: user.id.to_s,
      name: user.name,
      email: user.email,
      mobile: user.mobile
    }
  }
)
```

#### Verifying a User

```ruby
response = ThisData.verify(
  ip: request.remote_ip,
  user_agent: request.user_agent,
  verb: ThisData::Verbs::LOG_IN,
  user: {
    id: user.id
  }
)

if response.risk_level.eql? ThisData::RISK_LEVEL_GREEN
  # Let them log in
else
  # Challenge for a Two Factor Authentication code
end
```


#### Getting Events (Audit Log)

```ruby
events = ThisData::Event.all(
  verb: ThisData::Verbs::LOG_IN,
  user_id: user.id,
  limit: 25,
  offset: 50
)
```

### Rails

#### Set Up

We have a generator which will set some nice configuration options for Ruby on
Rails users.

Find your API key by going to [ThisData](https://thisdata.com) >
  Integrations > Login Intelligence API.

Run:

```ruby
rails g this_data:install YOUR_API_KEY_HERE
```

The generator will create a file in `config/initializers` called "this_data.rb".
If you need to do any further configuration or customization of ThisData,
that's the place to do it!

#### Tracking

**The recommended way to track events is as above - explicitly calling
`ThisData.track`.**

However, we do provide a `ThisData::TrackRequest` module which, when included in
an ActionController, gives you a simple way to track requests. The advantage
is that this module knows how to get request details automagically, like the IP,
user agent, and ThisData's tracking cookie value (if you've turned that on).

You include the module, then call `thisdata_track`. Easy!

e.g. in your sessions controller:

```ruby
class SessionsController < ApplicationController
  include ThisData::TrackRequest

  def create
    if User.authenticate(params[:email], params[:password])
      # Do the things one usually does for a successful auth

      # And also track the login
      thisdata_track
    else
      # Their credentials are wrong. Are they trying to access
      # a valid account?
      if attempted_user = User.find_by(email: params[:email])
        thisdata_track(
          verb: ThisData::Verbs::LOG_IN_DENIED,
          user: attempted_user,
          authenticated: false
        )
      else
        # email and password were both incorrect
      end
    end
  end
end
```

Note: as with many sensitive operations, taking different actions when an
account exists vs. when an account doesn't exist can lead to a information
disclosure through timing attacks.


### Will this break my app?

We hope not! We encourage you to use the asynchronous API call where possible
just in case our end goes down. In all cases we have error handling to capture
hard failures, but there may be edge-cases where timeouts or other bugs haven't
been properly handled.

So in your own app you could move tracking to a background job, enforce timeouts,
add threading (safely!), or employ other methods which enforce good behaviour of
third party gems.

Read more: http://help.thisdata.com/docs/how-do-you-not-break-my-app


### Stuck?

The API endpoint validates the events you send, and will return errors in the
body of the response. Enabling logging will help you debug this.

Our documentation can be read at http://help.thisdata.com. Our API will return
error messages you can inspect if the payload is missing required attributes.

Reach out to developers@thisdata.com if you need any help, or open an issue!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisdata/thisdata-ruby.
