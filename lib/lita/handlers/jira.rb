require 'lita'
require 'jira'

module Lita
  module Handlers
    class Jira < Handler
      route(
        /^jira\s(\D*-\d*)$/,
        :issue_summary,
        command: true,
        help: { 'jira <issue ID>' => 'Shows summary for <issue ID>' }
      )

      route(
        /^jira\s(\D*-\d*)\sdetails$/,
        :issue_details,
        command: true,
        help: { 'jira <issue ID> details' => 'Shows detailed information for <issue ID>' }
      )

      def self.default_config(config)
        config.username = nil
        config.password = nil
        config.site     = nil
        config.context  = nil
      end

      def issue_summary(response)
        key = response.matches[0][0]
        issue = fetch_issue(key)
        if issue
          response.reply("#{key}: #{issue.summary}")
        else
          response.reply('Error fetching JIRA issue')
        end
      end

      def issue_details(response)
        key = response.matches[0][0]
        issue = fetch_issue(key)
        if issue
          response.reply("#{key}: #{issue.summary}, " \
                         "assigned to: #{issue.assignee.displayName}, " \
                         "priority: #{issue.priority.name}, " \
                         "status: #{issue.status.name}")
        else
          response.reply('Error fetching JIRA issue')
        end
      end

      private

      def j_client
        return if Lita.config.handlers.jira.username.nil? ||
                  Lita.config.handlers.jira.password.nil? ||
                  Lita.config.handlers.jira.site.nil?     ||
                  Lita.config.handlers.jira.context.nil?

        options = {
          username:      Lita.config.handlers.jira.username,
          password:      Lita.config.handlers.jira.password,
          site:          Lita.config.handlers.jira.site,
          context_path:  Lita.config.handlers.jira.context,
          auth_type:     :basic
        }

        JIRA::Client.new(options)
      end

      def fetch_issue(key)
        client = j_client
        if client
          begin
            client.Issue.find(key)
          rescue JIRA::HTTPError
            nil
          end
        end
      end
    end

    Lita.register_handler(Jira)
  end
end

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', '..', '..', 'locales', '*.yml'), __FILE__
)]
