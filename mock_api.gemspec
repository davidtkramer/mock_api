require_relative "lib/mock_api/version"

Gem::Specification.new do |spec|
  spec.name          = "mock_api"
  spec.version       = MockApi::VERSION
  spec.authors       = ["David Kramer"]
  spec.email         = ["david.kramer@redtailtechnology.com"]

  spec.summary       = "A library for building mock APIs in tests"
  spec.description   = "A library for building mock APIs in tests"
  spec.homepage      = "https://github.com/davidtkramer/mock_api"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.files = Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "sinatra", "~> 2.2.2"
  spec.add_development_dependency "sinatra-contrib"
end
