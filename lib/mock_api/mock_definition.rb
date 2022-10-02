module MockApi
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
