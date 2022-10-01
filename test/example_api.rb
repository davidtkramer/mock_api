require 'sinatra/base'
require 'sinatra/json'

class ExampleApi < Sinatra::Base
  include MockApi

  mock do
    url 'example.com'
    store :messages
  end

  # do not show sinatra html error output
  # set :show_exceptions, false
  # set :raise_errors, false
  #
  # error do
  #   content_type :json
  #   status 500
  #   error = env['sinatra.error']
  #   { :result => 'error', :message => error.message }.to_json
  # end

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
