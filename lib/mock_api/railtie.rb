module MockApi
  class Railtie < Rails::Railtie
    initializer "mock_api.add_mocks_to_autoload_paths", before: :set_autoload_paths do |app|
      app.config.autoload_paths << "#{Rails.root}/test/api_mocks"
    end
  end
end
