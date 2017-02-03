require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'jira-ruby'

require 'jirahelper/issue'
require 'jirahelper/misc'
require 'jirahelper/regex'
require 'jirahelper/utility'

require 'lita/handlers/jira_utility'
require 'lita/handlers/jira'
