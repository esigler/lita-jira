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
      include ::JiraHelper::Utility

      route(
        /^jira\s#{ISSUE_PATTERN}$/,
        :summary,
        command: true,
        help: {
          t('help.summary.syntax') => t('help.summary.desc')
        }
      )

      route(
        /^jira\sdetails\s#{ISSUE_PATTERN}$/,
        :details,
        command: true,
        help: {
          t('help.details.syntax') => t('help.details.desc')
        }
      )

      route(
        /^jira\smyissues$/,
        :myissues,
        command: true,
        help: {
          t('help.myissues.syntax') => t('help.myissues.desc')
        }
      )

      route(
        /^jira\scomment\son\s#{ISSUE_PATTERN}\s#{COMMENT_PATTERN}$/,
        :comment,
        command: true,
        help: {
          t('help.comment.syntax') => t('help.comment.desc')
        }
      )

      route(
        /^todo\s#{PROJECT_PATTERN}\s#{SUBJECT_PATTERN}(\s#{SUMMARY_PATTERN})?$/,
        :todo,
        command: true,
        help: {
          t('help.todo.syntax') => t('help.todo.desc')
        }
      )

      def summary(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        response.reply(t('issue.summary', key: issue.key, summary: issue.summary))
      end

      def details(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        response.reply(format_issue(issue))
      end

      def comment(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        comment = issue.comments.build
        comment.save!(body: response.match_data['comment'])
        response.reply(t('comment.added', issue: issue.key))
      end

      def todo(response)
        issue = create_issue(response.match_data['project'],
                             response.match_data['subject'],
                             response.match_data['summary'])
        return response.reply(t('error.request')) unless issue
        response.reply(t('issue.created', key: issue.key))
      end

      # rubocop:disable Metrics/AbcSize
      def myissues(response)
        return response.reply(t('error.not_identified')) unless user_stored?(response.user)

        begin
          issues = fetch_issues("assignee = '#{get_email(response.user)}' AND status not in (Closed)")
        rescue
          log.error('JIRA HTTPError')
          response.reply(t('error.request'))
          return
        end

        return response.reply(t('myissues.empty')) unless issues.size > 0

        response.reply(format_issues(issues))
      end
      # rubocop:enable Metrics/AbcSize
    end

    Lita.register_handler(Jira)
  end
end
