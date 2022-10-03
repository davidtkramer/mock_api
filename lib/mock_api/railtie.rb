module MockApi
  class Railtie < Rails::Railtie
    initializer "my_railtie.configure_rails_initialization" do |app|
      # app.config.autoload_paths << "#{root}/test/api_mocks"
      puts 'RUNNING INIT'
      puts "#{root}/test/api_mocks"
    end
  end
end
