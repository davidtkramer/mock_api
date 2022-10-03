module MockApi
  class Railtie < Rails::Railtie
    config.autoload_paths << "#{root}/test/api_mocks"
  end
end
