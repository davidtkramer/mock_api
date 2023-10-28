require 'mock_api'

module MockApi
  class Runner
    def hooks
      runner = self
      Module.new do
        define_singleton_method :included do |klass|
          klass.class_eval do
            before do
              runner.reset
              runner.run
            end
            after do
              runner.reset
            end
          end
        end
      end
    end
  end
end
