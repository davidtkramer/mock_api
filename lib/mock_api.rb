require 'mock_api/version'
require 'mock_api/mock_definition'
require 'mock_api/runner'
require 'mock_api/store_registry'
require 'mock_api/railtie' if defined?(Rails::Railtie)

module MockApi
  def self.included(klass)
    klass.extend(ClassMethods)
    class << klass
      attr_accessor :runner
    end
  end

  module ClassMethods
    def mock(&block)
      definition = MockDefinition.new
      definition.instance_exec(&block)
      store = nil
      unless definition.entity_types.nil?
        store = StoreRegistry.register(name, definition.entity_types)
        extend(store.mixin)
        include(store.mixin)
      end
      self.runner = Runner.new(url: definition._url, server: self, store: store)
    end

    def run(url = nil)
      url.nil? ? runner.run : runner.run(url)
    end

    def reset
      runner.reset
    end

    def hooks
      runner.hooks
    end
  end
end
