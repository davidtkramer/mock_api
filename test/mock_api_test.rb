require 'test_helper'
require 'example_api'

class MockApiTest < Minitest::Test
  def setup
    ExampleApi.run
    # WebMock.globally_stub_request do |request|
    #   if request.uri.to_s =~ /example\.com/
    #     rack_response = WebMock::RackResponse.new(ExampleApi)
    #     response = rack_response.evaluate(request)
    #     { status: response.status, body: response.body, headers: response.headers }
    #   end
    # end
  end

  def teardown
    ExampleApi.reset
  end

  def test_creates_and_reads_article
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
