require_relative 'mock_api/version'
require_relative 'mock_api/runner'
require_relative 'mock_api/store_registry'

module MockApi
  def self.included(klass)
    klass.extend(ClassMethods)
    class << klass
      attr_accessor :runner, :store
    end
  end

  module ClassMethods
    def mock(&block)
      definition = MockDefinition.new
      definition.instance_exec(&block)
      store = nil
      unless definition.entity_types.nil?
        store = StoreRegistry.instance.find_or_create(name, definition.entity_types)
        extend(store.mixin)
        include(store.mixin)
      end
      self.runner = Runner.new(url: definition._url, server: self, store: store)
    end

    def hooks
      runner.hooks
    end

    def reset
      runner.reset
    end

    def run(url = nil)
      url.nil? ? runner.run : runner.run(url)
    end

    class MockDefinition
      attr_reader :_url, :entity_types

      def url(url)
        @_url = url
      end

      def store(*entity_types)
        @entity_types = entity_types
      end
    end
  end
end
