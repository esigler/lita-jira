# lita-jira plugin
module Lita
  # Because we can.
  module Handlers
    # Main handler
    class Jira < Handler
      namespace 'Jira'

      config :username, required: true
      config :password, required: true
      config :site, required: true
      config :context, required: true

      include ::JiraHelper::Issue
      include ::JiraHelper::Misc
      include ::JiraHelper::Regex

      route(
        /^jira\s(#{ISSUE_PATTERN})$/,
        :issue_summary,
        command: true,
        help: {
          'jira <issue ID>' => 'Shows summary for <issue ID>'
        }
      )

      route(
        /^jira\s(#{ISSUE_PATTERN})\sdetails$/,
        :issue_details,
        command: true,
        help: {
          'jira <issue ID> details' => 'Shows detailed information for <issue ID>' }
      )

      def issue_summary(response)
        key = response.matches[0][0]
        issue = fetch_issue(key)
        if issue
          response.reply("#{key}: #{issue.summary}")
        else
          response.reply(t('error.request'))
        end
      end

      def issue_details(response)
        key = response.matches[0][0]
        issue = fetch_issue(key)
        if issue
          response.reply(format_issue(issue))
        else
          response.reply(t('error.request'))
        end
      end
    end

    Lita.register_handler(Jira)
  end
end
