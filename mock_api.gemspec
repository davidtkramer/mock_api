# frozen_string_literal: true

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

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/davidtkramer/mock_api"
  spec.metadata["changelog_uri"] = "https://github.com/davidtkramer/mock_api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
