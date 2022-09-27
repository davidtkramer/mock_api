module MockApi
  class Runner
    def initialize(url:, server:, store: nil)
      @url = Regexp.new(url)
      @server = server
      @store = store
      extend(store.mixin) unless store.nil?
    end

    def run(url = @url)
      WebMock.stub_request(:any, url).to_rack(@server)
    end

    def reset
      @store&.reset
    end

    def hooks
      this = self
      Module.new do
        define_singleton_method :included do |klass|
          klass.class_eval do
            setup { this.run }
            teardown { this.reset }
          end
        end
      end
    end
  end
end
