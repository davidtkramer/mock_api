require 'sinatra/base'
require 'sinatra/json'
require 'faraday'
require 'test_helper'

class ExampleApi < Sinatra::Base
  include MockApi

  mock do
    url 'example.com'
    store :messages
  end

  post '/messages' do
    body = JSON.parse(request.body.read)
    message = messages.add({ id: SecureRandom.uuid, text: body['text'] })
    json message
  end

  get '/messages/:id' do
    message = messages.find { |a| a[:id] == params[:id] }
    status 404 and next if message.nil?
    json message
  end
end

class MockApiTest < Minitest::Test
  def setup
    ExampleApi.run
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
