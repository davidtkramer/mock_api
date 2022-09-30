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
# test/mock_apis/contact_api.rb
class ContactApi < Sinatra::Base
  include MockApi

  mock do
    # Intercept requests to this url and route them to this api.
    url 'example.com'
  end

  get '/contacts/:id' do
    json({ id: params[:id], name: 'Bob' })
  end
end
```

Then use it in your tests:

```ruby
class ContactApiTest < ActionDispatch::IntegrationTest
  # Include hooks to initialize request mocking before each test
  include ContactApi.hooks

  test 'fetches contact from the API' do
    # Verify that we can fetch the contact from the api.
    response = Faraday.get('http://example.com/contacts/123')
    body = JSON.parse(response.body)
    
    assert_equal '123', body['id']
    assert_equal 'Bob', body['name']
  end
end
```

## Test Setup

The simplest way to use a mock API in a test suite is to include the `hooks` module. This will setup your mock API to intercept requests before each test and reset any in-memory [stores](#dynamic-responses) after each test.

```ruby
class ContactApiTest < ActionDispatch::IntegrationTest
  include ContactApi.hooks
  
  # ...
end
```

If you prefer to setup the hooks yourself or need finger-grained control, the mock api can be manually started and reset:

```ruby
class ContactApiTest < ActionDispatch::IntegrationTest
  setup do
    ContactApi.run
  end
  
  teardown do
    ContactApi.reset
  end
  
  # ...
end
```
> Calling `reset` after each test is not necessary if your api does not have any in-memory stores

## Development Setup

The same mock APIs used in your tests can be also be used in development. Example setup for Rails:

```ruby
# config/initializers/mock_api.rb
if Rails.env.development?
  require_relative '../../test/mock_apis/contact_api'
  
  WebMock.enable!
  # If you're not mocking all requests in your app, then we need to tell
  # webmock to still allow real http requests. 
  WebMock.allow_net_connect!
  ContactApi.run
end
```

Any changes to your mock APIs will require restarting the development server. To autoload changes, place your mock API classes in a directory that's in the Rails `autoload_paths` config. The simplest approach is to create a `mock_apis` directory underneath `app`, and then Rails will automatically autoload all of your mock APIs. Then, setup your intializer like so:

```ruby
# config/initializers/mock_api.rb
if Rails.env.development?
  WebMock.enable!
  WebMock.allow_net_connect!

  Rails.application.reloader.to_prepare do
    ContactApi.run
  end
end
```

>  The state of any stores in your mock API will be reset whenever an autoload occurs

If you only want to mock a certain namespace or a specific endpoint in development, you can provide a url to the `run` method. This url will override the default url specified in the mock api class.

```ruby
# only mock requests to the /contacts namespace
ContactApi.run('http://example.com/contacts')
```

## Dynamic Responses

In many cases, your mock api can just return hard-coded responses or fixture data. If you need more flexibility, the `MockApi` module provides a store interface to help you manage dynamic responses.

For example, imagine we're building an API endpoint that fetches a contact from an external service managed by another team. 

```ruby
class ContactsController < ApplicationController
  def show
    response = Faraday.get("http://example.com/contacts/#{params[:id]}")
    if response.status == 404
      head 404
    else
      contact = JSON.parse(response.body)
      render json: contact  
    end
  end
end
```

We want to test these scenarios:

- If a contact with the provided ID exists in the external service, our endpoint responds with that contact
- If a contact with the provided ID is not found in the external service, our endpoint responds with a 404

To support this, let's refactor the mock API from the [Quick Start](#quick-start) section to be dynamic:

```ruby
class ContactApi < Sinatra::Base
  include MockApi

  mock do
    url 'example.com'
    # Configure one or more in-memory stores for entities managed by this api.
    store :contacts
  end

  get '/contacts/:id' do
    # We now have a contacts method that returns the contact store. The store is just a thin
    # wrapper around an array, so we can use any standard ruby array methods to search it.
    contact = contacts.find { |c| c[:id] == params[:id] }
    contact.nil ? status 404 : json contact
  end
end
```

Now, in our test we can verify our endpoint handles both scenarios:

```ruby
class ContactsControllerTest < ActionDispatch::IntegrationTest
  include ContactApi.hooks

  test 'fetches contact with provided ID' do
    # Add a contact to the in-memory contact store.
    contact = ContactApi.contacts.add({ id: '123', text: 'hello' })
    
    # Verify our api can fetch the contact from the external service.
    get "/contacts/#{contact[:id]}"
    
    assert_response 200
    body = JSON.parse(response.body)
    assert_equal contact[:id], body['id']
    assert_equal contact[:text], body['text']
  end
  
  test 'returns 404 if contact is not found' do
    # In this test, we add nothing to the contact store, so our mock api
    # endpoint should return a 404. In turn, our endpoint should 404 as well.
    get '/contacts/123'

    assert_response 404
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
