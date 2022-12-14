require_relative 'store'

module MockApi
  module StoreRegistry
    class << self
      attr_accessor :stores
    end

    self.stores = {}

    def self.register(name, entity_types)
      return stores[name] if stores.key?(name)
      stores[name] = Store.new(*entity_types)
    end
  end
end
