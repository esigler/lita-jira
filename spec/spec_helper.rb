require 'simplecov'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start { add_filter '/spec/' }

require 'lita-jira'
require 'lita/rspec'

Lita.version_3_compatibility_mode = false

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # TODO: Enable
  # config.mock_with :rspec do |mocks|
  #   mocks.verify_partial_doubles = true
  # end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random

  Kernel.srand config.seed
end

def grab_request(result)
  allow(JIRA::Client).to receive(:new) { result }
end
