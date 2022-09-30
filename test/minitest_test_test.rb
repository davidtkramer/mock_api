require 'test_helper'
require 'example_api'

Hooks = { before_called: false, after_called: false }

class MinitestTestTest < Minitest::Test
  # We need these tests to execute in order so we can test that the user-defined
  # after hook is called correctly and test that the store is reset.
  i_suck_and_my_tests_are_order_dependent!
  include ExampleApi.hooks

  def setup
    Hooks[:before_called] = true
  end

  def teardown
    Hooks[:after_called] = true
  end

  def test_a_does_not_prevent_user_defined_before_hooks_from_running
    assert Hooks[:before_called]
  end

  def test_b_does_not_prevent_user_defined_after_hooks_from_running
    assert Hooks[:after_called]
  end

  def test_c_mocks_requests
    Faraday.post('http://example.com/messages', { text: 'hello' }.to_json)
    assert_equal 1, ExampleApi.messages.length
  end

  def test_d_resets_store_after_each_test
    assert_empty ExampleApi.messages
  end
end
