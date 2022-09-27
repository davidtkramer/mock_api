# MockApi

MockApi simplifies building mock APIs with WebMock and Sinatra for tests and development.

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'mock_api'
gem 'webmock'
gem 'sinatra'
# sinatra-contrib is optional, but contains useful helpers for json APIs
gem 'sinatra-contrib'
```

And then run:

    $ bundle install

## Quick Start

Setup dependencies:

```ruby
# test/test_helper.rb
require 'webmock/minitest' # If using rspec, require 'webmock/rspec' instead 
require 'sinatra/base'
require 'sinatra/json'
require 'mock_api'
```

Create an api with Sinatra and include the `MockApi` module:

```ruby
# test/mock_apis/message_api.rb
class MessageApi < Sinatra::Base
  include MockApi

  mock do
    # Intercept requests to this url and route them to this api.
    url 'example.com'
    # Configure in-memory store(s) for entities managed by this api.
    store :messages
  end

  get '/messages/:id' do
    message = messages.find { |a| a[:id] == params[:id] }
    message.nil ? status 404 : json message
  end
end
```

Then use it in your tests:

```ruby
class MessageApiTest < ActionDispatch::IntegrationTest
  # Includes hooks to initialize request mocking before each test
  # and reset the state of any in-memory stores after each test.
  include MessageApi.hooks

  test 'fetches message from the API' do
    # Add a message to the in-memory message store.
    message = MessageApi.messages.add({ id: '123', text: 'hello' })
    # Verify that we can fetch the message from the api.
    response = Faraday.get("http://example.com/messages/#{message[:id]}")
    body = JSON.parse(response.body)
    assert_equal message[:id], body['id']
    assert_equal message[:text], body['text']
  end
end
```

## Test Usage

The simplest way to use a mock API in tests is to include the `hooks` module. This will setup your mock API to intercept requests before each test and reset the in-memory store after each test.

```ruby
# message_api_test.rb
class MessageApiTest < ActionDispatch::IntegrationTest
  include MessageApi.hooks
  
  # ...
end
```

If you prefer to setup the hooks yourself or need finger-grained control, the mock api can be manually started and reset:

```ruby
class MessageApiTest < ActionDispatch::IntegrationTest
  setup do
    MessageApi.run
  end
  
  teardown do
    MessageApi.reset
  end
  
  # ...
end
```
> Calling `reset` after each test is not necessary if your api does not have any in-memory stores

## Store

TBD

## Manual Setup

TBD

## Usage with FactoryBot

TBD

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
