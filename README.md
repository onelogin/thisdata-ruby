# ThisData Ruby

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

### Ruby

Configure ThisData as follows:

```
ThisData.setup do |config|
  config.api_key = "API_KEY_HERE"
end
```

You can then track any event by calling `ThisData.track` and passing a Hash which
contains an event. See examples and required fields on our API documentation:
http://help.thisdata.com/docs/apiv1events

**Important!** You should not commit your API keys to source control. Where
possible, use environment variables / a non-committed secrets file / something
similar.

### Rails

Find your API key by going to [ThisData](https://thisdata.com) >
  Integrations > Login Intelligence API.

Run:

    rails g this_data:install YOUR_API_KEY_HERE

The generator will create a file in `config/initializers` called "this_data.rb".
If you need to do any further configuration or customization of ThisData,
that's the place to do it!

The ThisData::TrackRequest module can be included in a ActionController, giving
you a handy way to track requests.

e.g. in `app/controllers/application_controller.rb`

    class ApplicationController < ActionController::Base
      include ThisData::TrackRequest

      ...
    end


and in your sessions controller:

    class SessionsController
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
              user: attempted_user
            )
          else
            # email and password were both incorrect
          end
        end
      end
    end

Note: as with many sensitive operations, taking different actions when an
account exists vs. when an account doesn't exist can lead to a information
disclosure through timing attacks.


### Stuck?

By default there is no logger configured, and requests are performed
asynchronously. The following config settings can be helpful in debugging issues:

`config/initializers/this_data.rb`
```
ThisData.setup do |config|
  # ...

  config.logger = Rails.logger # or Logger.new($stdout)
  config.async  = false
end
```

Our documentation can be read at http://help.thisdata.com. Our API will return
error messages you can inspect if the payload is missing required attributes.

Reach out to developers@thisdata.com if you need any help, or open an issue!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisdata/thisdata-ruby.
