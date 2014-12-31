# lita-jira plugin
module Lita
  # Because we can.
  module Handlers
    # Utilities
    class JiraUtility < Handler
      namespace 'Jira'

      include ::JiraHelper::Issue
      include ::JiraHelper::Misc
      include ::JiraHelper::Regex
      include ::JiraHelper::Utility

      route(
        /^jira\sidentify\s(?<email>.*)$/,
        :identify,
        command: true,
        help: {
          t('help.identify.syntax') => t('help.identify.desc')
        }
      )

      route(
        /^jira\sforget$/,
        :forget,
        command: true,
        help: {
          t('help.forget.syntax') => t('help.forget.desc')
        }
      )

      route(
        /^jira\swhoami$/,
        :whoami,
        command: true,
        help: {
          t('help.whoami.syntax') => t('help.whoami.desc')
        }
      )

      def identify(response)
        email = response.match_data['email']
        return response.reply(t('error.already_identified', email: get_email(response.user))) if user_stored?(response.user)
        store_user!(response.user, email)
        response.reply(t('identify.stored', email: email))
      end

      def forget(response)
        return response.reply(t('error.not_identified')) unless user_stored?(response.user)
        delete_user!(response.user)
        response.reply(t('identify.deleted'))
      end

      def whoami(response)
        return response.reply(t('error.not_identified')) unless user_stored?(response.user)
        response.reply(t('identify.email', email: get_email(response.user)))
      end

      Lita.register_handler(JiraUtility)
    end
  end
end
