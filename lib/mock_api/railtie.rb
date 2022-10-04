module MockApi
  class Railtie < Rails::Railtie
    initializer "mock_api.add_mocks_to_autoload_paths", before: :set_autoload_paths do |app|
      paths = ["#{Rails.root}/test/api_mocks", "#{Rails.root}/spec/api_mocks"]
      paths
        .select { |path| Dir.exist?(path) }
        .each { |path| app.config.autoload_paths << path }
    end
  end
end
