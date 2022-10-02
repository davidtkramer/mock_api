module MockApi
  class Runner
    def initialize(url:, server:, store: nil)
      @url = Regexp.new(url)
      @server = server
      @store = store
      extend(store.mixin) unless store.nil?
    end

    def run(url = @url)
      if defined?(::WebMock)
        WebMock.stub_request(:any, url).to_rack(@server)
      else
        raise 'MockApi requires WebMock to be installed. ' \
          'Check out the setup guide at https://github.com/davidtkramer/mock_api#quick-start.'
      end
    end

    def reset
      @store&.reset
    end

    def hooks
      raise "hooks method needs 'mock_api/minitest' or 'mock_api/rspec' to be required"
    end
  end
end
