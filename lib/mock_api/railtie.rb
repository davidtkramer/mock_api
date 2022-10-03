module MockApi
  class Railtie < Rails::Railtie
    initializer "my_railtie.configure_rails_initialization" do |app|
      puts 'RUNNING INITIALIZER'
      puts app.config.autoload_paths.inspect
    end
  end
end
