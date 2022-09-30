$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'minitest/autorun'
require 'webmock/minitest'
require 'faraday'
require 'mock_api'
