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
        /^jira\s#{ISSUE_PATTERN}$/,
        :summary,
        command: true,
        help: {
          'jira <issue ID>' => 'Shows summary for <issue ID>'
        }
      )

      route(
        /^jira\sdetails\s#{ISSUE_PATTERN}$/,
        :details,
        command: true,
        help: {
          'jira <issue ID> details' => 'Shows detailed information for <issue ID>' }
      )

      def summary(response)
        key = response.match_data['issue']
        issue = fetch_issue(key)
        return response.reply(t('error.request')) unless issue
        response.reply("#{key}: #{issue.summary}")
      end

      def details(response)
        key = response.match_data['issue']
        issue = fetch_issue(key)
        return response.reply(t('error.request')) unless issue
        response.reply(format_issue(issue))
      end
    end

    Lita.register_handler(Jira)
  end
end
