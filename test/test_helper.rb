$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'minitest/autorun'
require 'webmock/minitest'
require 'mock_api/minitest'
require 'sinatra/base'
require 'sinatra/json'
require 'faraday'
