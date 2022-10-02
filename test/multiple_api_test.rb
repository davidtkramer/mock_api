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

class MultipleApiTest < Minitest::Test
  include ApiOne.hooks
  include ApiTwo.hooks

  def test_multiple_apis_can_be_mocked_in_one_test
    Faraday.get('http://one.com/resource')
    Faraday.get('http://two.com/resource')
  end
end
