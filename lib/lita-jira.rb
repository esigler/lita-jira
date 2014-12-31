require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'jira'

require 'jirahelper/issue'
require 'jirahelper/misc'
require 'jirahelper/regex'

require 'lita/handlers/jira'
