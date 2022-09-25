require 'sinatra/base'
require_relative "mock_api/version"

module MockApi
  def self.included(klass)
    klass.extend(ClassMethods)
    class << klass
      attr_accessor :store, :server, :url
    end
    klass.server = Class.new(Sinatra::Base)
  end

  module ClassMethods
    def entities(*entity_types)
      raise 'entities have already been defined' unless store.nil?
      self.store = EntityStore.new(entity_types)
      store = self.store
      entity_types.each do |entity_type|
        define_singleton_method(entity_type) { store[entity_type] }
        server.define_method(entity_type) { store[entity_type] }
      end
    end

    def root(url)
      self.url = Regexp.new(url)
    end

    def get(*args, &block)
      server.get(*args, &block)
    end

    def post(*args, &block)
      server.post(*args, &block)
    end

    def put(*args, &block)
      server.put(*args, &block)
    end

    def delete(*args, &block)
      server.delete(*args, &block)
    end

    def hooks
      url = self.url
      server = self.server
      store = self.store
      Module.new do
        define_singleton_method :included do |klass|
          klass.class_eval do
            setup { stub_request(:any, url).to_rack(server) }
            teardown { store.reset }
          end
        end
      end
    end
  end

  class EntityStore
    def initialize(entity_types)
      @store = {}
      entity_types.each do |entity_type|
        @store[entity_type] = EntityRepo.new([])
      end
    end

    def add(entity_type, entity)
      @store[entity_type].add(entity)
    end

    def [](entity_type)
      @store[entity_type]
    end

    def reset
      @store.transform_values! { EntityRepo.new([]) }
    end
  end

  class EntityRepo < SimpleDelegator
    def add(entity)
      push(entity)
      entity
    end
  end
end
