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

Run:

    rails g this_data:install YOUR_API_KEY_HERE

You can find your API key by going to [ThisData](https://thisdata.com) >
  Integrations > Login Intelligence API.

The generator will create a file in `config/initializers` called "this_data.rb".
If you need to do any further configuration or customization of ThisData,
that's the place to do it!

## Ruby

You can track any event by calling `ThisData.track` and passing a Hash which
contains an event. See examples and required fields on our API documentation:
http://help.thisdata.com/docs/apiv1events

## Rails

The ThisData::TrackRequest module can be included in a ActionController, giving
you a handy way to track requests.

e.g. in `app/controllers/application_controller.rb`
```
class ApplicationController < ActionController::Base
  include ThisData::TrackRequest

  ...
end
```

and in your sessions controller:
```
class SessionsController < ApplicationController

  def finalize
    if login_was_valid?
      # do login stuff
      thisdata_track
    else
      thisdata_track('login-denied')
    end
  end

end
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/revertio/thisdata-ruby.
