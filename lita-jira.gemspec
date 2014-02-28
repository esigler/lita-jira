Gem::Specification.new do |spec|
  spec.name          = "lita-jira"
  spec.version       = "0.0.1"
  spec.authors       = ["Eric Sigler"]
  spec.email         = ["me@esigler.com"]
  spec.description   = %q{A Lita handler for interacting with a JIRA ticket tracker.}
  spec.summary       = %q{A Lita handler for interacting with a JIRA ticket tracker.}
  spec.homepage      = "https://github.com/esigler/lita-jira"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.0"
  spec.add_runtime_dependency "jira-ruby", ">= 0.1.8"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0.beta2"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
