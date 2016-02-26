# Helper functions for lita-jira
module JiraHelper
  # Misc
  module Misc
    def client
      JIRA::Client.new(
        username: config.username,
        password: config.password,
        site: config.site,
        context_path: config.context,
        auth_type: :basic,
        use_ssl: config.use_ssl
      )
    end
  end
end
