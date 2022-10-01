require_relative 'store'

module MockApi
  class StoreRegistry
    include Singleton

    def initialize
      @stores = {}
    end

    def find_or_create(name, entity_types)
      return @stores[name] if @stores.key?(name)
      @stores[name] = Store.new(*entity_types)
    end
  end
end
