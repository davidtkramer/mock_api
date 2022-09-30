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
            if klass.method_defined?(:before_setup) # minitest
              klass.define_method(:before_setup) do
                super()
                this.run
              end
            elsif respond_to?(:setup) # rails
              setup { this.run }
            elsif respond_to?(:before) # rspec
              before { this.run }
            else
              raise "Unable to initialize MockApi setup hook in #{klass}"
            end

            if klass.method_defined?(:before_teardown)
              klass.define_method(:before_teardown) do # minitest
                super()
                this.reset
              end
            elsif respond_to?(:teardown) # rails
              teardown { this.reset }
            elsif respond_to?(:after) # rspec
              after { this.reset }
            else
              raise "Unable to initialize MockApi teardown hook in #{klass}"
            end
          end
        end
      end
    end
  end
end
