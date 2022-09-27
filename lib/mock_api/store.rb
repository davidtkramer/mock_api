module MockApi
  class Store
    def initialize(*entity_types)
      @store = {}
      @entity_types = entity_types
      entity_types.each do |entity_type|
        @store[entity_type] = Repository.new([])
      end
    end

    def add(entity_type, entity)
      @store[entity_type].add(entity)
    end

    def [](entity_type)
      @store[entity_type]
    end

    def reset
      @store.transform_values! { Repository.new([]) }
    end

    def mixin
      store = @store
      entity_types = @entity_types
      Module.new do
        define_singleton_method :included do |klass|
          entity_types.each do |entity_type|
            klass.define_method(entity_type) { store[entity_type] }
          end
        end
        define_singleton_method :extended do |klass|
          entity_types.each do |entity_type|
            klass.define_singleton_method(entity_type) { store[entity_type] }
          end
        end
      end
    end

    class Repository < SimpleDelegator
      def add(entity)
        push(entity)
        entity
      end
    end
  end
end
