module Lita
  module Handlers
    class Jira < Handler
      route(
        /^todo\s(.*)$/,
        :todo,
        command: true,
        help: {
          'todo <summary>' =>
          'Creates an issue with your default priority and project settings, assigned to yourself'
        }
      )

      route(
        /^jira\sissue\sassignee\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_assignee_list,
        command: true,
        help: {
          'jira issue assignee <issue ID>' => 'Shows assignee of <issue ID>'
        }
      )

      route(
        /^jira\sissue\sassignee\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_assignee_set,
        command: true,
        help: {
          'jira issue assignee <issue ID> <email address>' => 'Sets <email address> as the assignee'
        }
      )

      route(
        /^jira\sissue\sattachments\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_attachments_list,
        command: true,
        help: {
          'jira issue attachments <issue ID>' => 'Shows all attachments for <issue ID>'
        }
      )

      route(
        /^jira\sissue\sattachments\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_attachments_set,
        command: true,
        help: {
          'jira issue attachments <issue ID> <URL>' => 'Adds <URL> as an attachment on <issue ID>'
        }
      )

      route(
        /^jira\sissue\scomments\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_comments_list,
        command: true,
        help: {
          'jira issue comments <issue ID>' => 'Shows all comments for <issue ID>'
        }
      )

      route(
        /^jira\sissue\scomments\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_comments_add,
        command: true,
        help: {
          'jira issue comments <issue ID> <text>' => 'Adds <text> as a comment on <issue ID>'
        }
      )

      route(
        /^jira\sissue\sdetails\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_details,
        command: true,
        help: {
          'jira issue details <issue ID>' => 'Shows all details for <issue ID>'
        }
      )

      route(
        /^jira\sissue\sissuetype\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_issuetype_list,
        command: true,
        help: {
          'jira issue issuetype <issue ID>' => 'Shows the Issue Type of <issue ID>'
        }
      )

      route(
        /^jira\sissue\sissuetype\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(\d+)$/,
        :issue_issuetype_set,
        command: true,
        help: {
          'jira issue issuetype <issue ID> <issuetype ID>' => 'Sets the Issue Type of <issue ID> to <issuetype ID>'
        }
      )

      route(
        /^jira\sissue\snew\s([a-zA-Z0-9]{1,4})\s(.+)$/,
        :issue_new,
        help: {
          t('help.issue.new.syntax') => t('help.issue.new.desc')
        }
      )

      route(
        /^jira\sissue\snotify\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_notify_list,
        help: {
          t('help.issue.notify_list.syntax') => t('help.issue.notify_list.desc')
        }
      )

      route(
        /^jira\sissue\snotify\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_notify_set,
        help: {
          t('help.issue.notify_set.syntax') => t('help.issue.notify_set.desc')
        }
      )

      route(
        /^jira\sissue\spriority\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_priority_list,
        help: {
          t('help.issue.priority_list.syntax') => t('help.issue.priority_list.desc')
        }
      )

      route(
        /^jira\sissue\spriority\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(\d+)$/,
        :issue_priority_set,
        help: {
          t('help.issue.priority_set.syntax') => t('help.issue.priority_set.desc')
        }
      )

      route(
        /^jira\sissue\ssummary\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_summary_list,
        help: {
          t('help.issue.summary_list.syntax') => t('help.issue.summary_list.desc')
        }
      )

      route(
        /^jira\sissue\ssummary\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_summary_set,
        help: {
          t('help.issue.summary_set.syntax') => t('help.issue.summary_set.desc')
        }
      )

      route(
        /^jira\sissue\swatchers\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_watchers_list,
        help: {
          t('help.issue.watchers_list.syntax') => t('help.issue.watchers_list.desc')
        }
      )

      route(
        /^jira\sissue\swatchers\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\s(.+)$/,
        :issue_watchers_set,
        help: {
          t('help.issue.watchers_set.syntax') => t('help.issue.watchers_set.desc')
        }
      )

      route(
        /^jira\sissuetype\slist\s([a-zA-Z0-9]{1,4})$/,
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
        /^jira\ssearch\s([a-zA-Z0-9]{1,4})\s(.+)$/,
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
        /^jira\sdefault\sproject\s([a-zA-Z0-9]{1,4})$/,
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

      # route(
      #   /^$/,
      #   :,
      #   help: {
      #     t('help..syntax') => t('help..desc')
      #   }
      # )

      route(
        /^jira\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})$/,
        :issue_summary,
        command: true,
        help: { 'jira <issue ID>' => 'Shows summary for <issue ID>' }
      )

      route(
        /^jira\s([a-zA-Z0-9]{1,4}-[0-9]{1,5})\sdetails$/,
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

      def todo(response)
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

      private

      def j_client
        if Lita.config.handlers.jira.username.nil? ||
           Lita.config.handlers.jira.password.nil? ||
           Lita.config.handlers.jira.site.nil?     ||
           Lita.config.handlers.jira.context.nil?
          Lita.logger.error('Missing config for JIRA')
          fail 'Missing config'
        end

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
