require 'test_helper'
require 'example_api'

before_called = false
after_called = false

describe 'Minitest::Spec hooks support' do
  # We need these tests to execute in order so we can test that the user-defined
  # after hook is called correctly and test that the store is reset.
  i_suck_and_my_tests_are_order_dependent!
  include ExampleApi.hooks

  before do
    before_called = true
  end

  after do
    after_called = true
  end

  it 'does not prevent user-defined before hooks from running' do
    assert before_called
  end

  it 'does not prevent user-defined after hooks from running' do
    assert after_called
  end

  it 'mocks api requests' do
    Faraday.post('http://example.com/messages', { text: 'hello' }.to_json)
    assert_equal 1, ExampleApi.messages.length
  end

  it 'resets store after each test' do
    assert_empty ExampleApi.messages
  end
end
