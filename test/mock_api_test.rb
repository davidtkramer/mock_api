require 'test_helper'
require 'example_api'

describe MockApi do
  before do
    ExampleApi.run
  end

  after do
    ExampleApi.reset
  end

  it 'creates and reads article' do
    params = { text: 'hello' }
    response = Faraday.post('http://example.com/messages', params.to_json)
    body = JSON.parse(response.body)

    assert_equal 1, ExampleApi.messages.length
    message = ExampleApi.messages.first
    assert_equal body['id'], message[:id]
    assert_equal body['text'], message[:text]

    response = Faraday.get("http://example.com/messages/#{message[:id]}")
    body = JSON.parse(response.body)
    assert_equal body['id'], message[:id]
  end
end
