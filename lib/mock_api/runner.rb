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
      this = self
      Module.new do
        define_singleton_method :included do |klass|
          klass.class_eval do
            if respond_to?(:setup)
              setup { this.run } # rails integration test
            elsif respond_to?(:before)
              before { this.run } # rspec + minitest/spec
            end

            if respond_to?(:teardown)
              teardown { this.reset } # rails integration test
            elsif respond_to?(:after)
              after { this.reset } # rspec + minitest/spec
            end
          end
        end
      end
    end
  end
end
