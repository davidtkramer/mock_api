require 'mock_api'

module MockApi
  class Runner
    def hooks
      runner = self
      Module.new do
        define_method :before_setup do
          runner.run
          super()
        end
        define_method :after_teardown do
          super()
          runner.reset
        end
      end
    end
  end
end

