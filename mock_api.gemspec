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

  spec.add_dependency "sinatra", "~> 2.2.2" # TODO: change to dev dep
end
