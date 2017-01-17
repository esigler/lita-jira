Gem::Specification.new do |spec|
  spec.name          = 'lita-jira'
  spec.version       = '0.8.1'
  spec.authors       = ['Eric Sigler', 'Matt Critchlow', 'Tristan Chong', 'Lee Briggs']
  spec.email         = ['me@esigler.com', 'matt.critchlow@gmail.com', 'ong@tristaneuan.ch', 'lee@brig.gs']
  spec.description   = 'A JIRA plugin for Lita.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/esigler/lita-jira'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.0'
  spec.add_runtime_dependency 'jira-ruby'
  spec.add_runtime_dependency 'activesupport', ['>= 4.0', '< 5.0']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'jira'
end
