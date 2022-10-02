require 'test_helper'

class ApiOne < Sinatra::Base
  include MockApi

  mock do
    url 'one.com'
  end

  get '/resource' do
    status 200
  end
end

class ApiTwo < Sinatra::Base
  include MockApi

  mock do
    url 'two.com'
  end

  get '/resource' do
    status 200
  end
end

describe 'Multiple API Test' do
  include ApiOne.hooks
  include ApiTwo.hooks

  it 'can mock multiple APIs in one test' do
    Faraday.get('http://one.com/resource')
    Faraday.get('http://two.com/resource')
  end
end
