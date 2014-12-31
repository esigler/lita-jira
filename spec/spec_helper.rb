require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start { add_filter '/spec/' }

require 'lita-jira'
require 'lita/rspec'

Lita.version_3_compatibility_mode = false

def grab_request(result)
  expect(JIRA::Client).to receive(:new) { result }
end
