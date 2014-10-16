module Lita
  module Handlers
    class Jira < Handler
      PROJECT_PATTERN = "[a-zA-Z0-9]{1,10}"
      ISSUE_PATTERN = "#{PROJECT_PATTERN}-[0-9]{1,5}"

      route(
        /^todo\s(.*)$/,
        :todo,
        command: true,
        help: {
          t('help.todo.syntax') => t('help.todo.desc')
        }
      )

      route(
        /^jira\sissue\sassignee\s(#{ISSUE_PATTERN})$/,
        :issue_assignee_list,
        command: true,
        help: {
          t('help.issue.assignee_list.syntax') => t('help.issue.assignee_list.desc')
        }
      )

      route(
        /^jira\sissue\sassignee\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_assignee_set,
        command: true,
        help: {
          t('help.issue.assignee_set.syntax') => t('help.issue.assignee_set.syntax')
        }
      )

      route(
        /^jira\sissue\sattachments\s(#{ISSUE_PATTERN})$/,
        :issue_attachments_list,
        command: true,
        help: {
          t('help.issue.attachments_list.syntax') => t('help.issue.attachments_list.desc')
        }
      )

      route(
        /^jira\sissue\sattachments\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_attachments_set,
        command: true,
        help: {
          t('help.issue.attachments_set.syntax') => t('help.issue.attachments_set.desc')
        }
      )

      route(
        /^jira\sissue\scomments\s(#{ISSUE_PATTERN})$/,
        :issue_comments_list,
        command: true,
        help: {
          t('help.issue.comments_list.syntax') => t('help.issue.comments_list.desc')
        }
      )

      route(
        /^jira\sissue\scomments\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_comments_add,
        command: true,
        help: {
          t('help.issue.comments_set.syntax') => t('help.issue.comments_set.desc')
        }
      )

      route(
        /^jira\sissue\sdetails\s(#{ISSUE_PATTERN})$/,
        :issue_details,
        command: true,
        help: {
          t('help.issue.details.syntax') => t('help.issue.details.desc')
        }
      )

      route(
        /^jira\sissue\sissuetype\s(#{ISSUE_PATTERN})$/,
        :issue_issuetype_list,
        command: true,
        help: {
          t('help.issue.issuetype_list.syntax') => t('help.issue.issuetype_list.desc')
        }
      )

      route(
        /^jira\sissue\sissuetype\s(#{ISSUE_PATTERN})\s(\d+)$/,
        :issue_issuetype_set,
        command: true,
        help: {
          t('help.issue.issuetype_set.syntax') => t('help.issue.issuetype_set.desc')
        }
      )

      route(
        /^jira\sissue\snew\s(#{PROJECT_PATTERN})\s(.+)$/,
        :issue_new,
        help: {
          t('help.issue.new.syntax') => t('help.issue.new.desc')
        }
      )

      route(
        /^jira\sissue\snotify\s(#{ISSUE_PATTERN})$/,
        :issue_notify_list,
        help: {
          t('help.issue.notify_list.syntax') => t('help.issue.notify_list.desc')
        }
      )

      route(
        /^jira\sissue\snotify\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_notify_set,
        help: {
          t('help.issue.notify_set.syntax') => t('help.issue.notify_set.desc')
        }
      )

      route(
        /^jira\sissue\spriority\s(#{ISSUE_PATTERN})$/,
        :issue_priority_list,
        help: {
          t('help.issue.priority_list.syntax') => t('help.issue.priority_list.desc')
        }
      )

      route(
        /^jira\sissue\spriority\s(#{ISSUE_PATTERN})\s(\d+)$/,
        :issue_priority_set,
        help: {
          t('help.issue.priority_set.syntax') => t('help.issue.priority_set.desc')
        }
      )

      route(
        /^jira\sissue\ssummary\s(#{ISSUE_PATTERN})$/,
        :issue_summary_list,
        help: {
          t('help.issue.summary_list.syntax') => t('help.issue.summary_list.desc')
        }
      )

      route(
        /^jira\sissue\ssummary\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_summary_set,
        help: {
          t('help.issue.summary_set.syntax') => t('help.issue.summary_set.desc')
        }
      )

      route(
        /^jira\sissue\swatchers\s(#{ISSUE_PATTERN})$/,
        :issue_watchers_list,
        help: {
          t('help.issue.watchers_list.syntax') => t('help.issue.watchers_list.desc')
        }
      )

      route(
        /^jira\sissue\swatchers\s(#{ISSUE_PATTERN})\s(.+)$/,
        :issue_watchers_set,
        help: {
          t('help.issue.watchers_set.syntax') => t('help.issue.watchers_set.desc')
        }
      )

      route(
        /^jira\sissuetype\slist\s(#{PROJECT_PATTERN})$/,
        :issuetype_list,
        help: {
          t('help.issuetype.list.syntax') => t('help.issuetype.list.desc')
        }
      )

      route(
        /^jira\ssearch\s(.+)$/,
        :search_full,
        help: {
          t('help.search.full.syntax') => t('help.search.full.desc')
        }
      )

      route(
        /^jira\ssearch\s(#{PROJECT_PATTERN})\s(.+)$/,
        :search_project,
        help: {
          t('help.search.project.syntax') => t('help.search.project.desc')
        }
      )

      route(
        /^jira\sidentify\s(.+)$/,
        :identify,
        help: {
          t('help.identify.syntax') => t('help.identify.desc')
        }
      )

      route(
        /^jira\sforget$/,
        :forget,
        help: {
          t('help.forget.syntax') => t('help.forget.desc')
        }
      )

      route(
        /^jira\swhoami$/,
        :whoami,
        help: {
          t('help.whoami.syntax') => t('help.whoami.desc')
        }
      )

      route(
        /^jira\sdefault\sproject\s(#{PROJECT_PATTERN})$/,
        :default_project,
        help: {
          t('help.default.project.syntax') => t('help.default.project.desc')
        }
      )

      route(
        /^jira\sdefault\spriority\s(\d+)$/,
        :default_priority,
        help: {
          t('help.default.priority.syntax') => t('help.default.priority.desc')
        }
      )

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

      def todo(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_assignee_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_assignee_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_attachments_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_attachments_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_comments_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_comments_add(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_issuetype_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_issuetype_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_new(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_notify_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_notify_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_priority_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_priority_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_summary_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_summary_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_watchers_list(response)
        response.reply(t('error.not_implemented'))
      end

      def issue_watchers_set(response)
        response.reply(t('error.not_implemented'))
      end

      def issuetype_list(response)
        response.reply(t('error.not_implemented'))
      end

      def search_full(response)
        response.reply(t('error.not_implemented'))
      end

      def search_project(response)
        response.reply(t('error.not_implemented'))
      end

      def identify(response)
        response.reply(t('error.not_implemented'))
      end

      def forget(response)
        response.reply(t('error.not_implemented'))
      end

      def whoami(response)
        response.reply(t('error.not_implemented'))
      end

      def default_project(response)
        response.reply(t('error.not_implemented'))
      end

      def default_priority(response)
        response.reply(t('error.not_implemented'))
      end

      private

      def j_client
        if Lita.config.handlers.jira.username.nil? ||
           Lita.config.handlers.jira.password.nil? ||
           Lita.config.handlers.jira.site.nil?     ||
           Lita.config.handlers.jira.context.nil?
          Lita.logger.error('Missing config for JIRA')
          fail 'Missing config'
        end

        JIRA::Client.new(
          username: Lita.config.handlers.jira.username,
          password: Lita.config.handlers.jira.password,
          site: Lita.config.handlers.jira.site,
          context_path: Lita.config.handlers.jira.context,
          auth_type: :basic
        )
      end

      def fetch_issue(key)
        j_client.Issue.find(key)
        rescue JIRA::HTTPError
          Lita.logger.error('JIRA HTTPError')
          nil
      end

      def format_issue(issue)
        t('issue.details',
          key: issue.key,
          summary: issue.summary,
          assigned: issue.assignee.displayName,
          priority: issue.priority.name,
          status: issue.status.name)
      end
    end

    Lita.register_handler(Jira)
  end
end
