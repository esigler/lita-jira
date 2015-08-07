# Helper functions for lita-jira
module JiraHelper
  # Issues
  module Issue
    # NOTE: Prefer this syntax here as it's cleaner
    # rubocop:disable Style/RescueEnsureAlignment
    def fetch_issue(key, expected = true)
      client.Issue.find(key)
      rescue
        log.error('JIRA HTTPError') if expected
        nil
    end
    # rubocop:enable Style/RescueEnsureAlignment

    # Leverage the jira-ruby Issue.jql search feature
    #
    # @param [Type String] jql Valid JQL query
    # @return [Type Array] 0-m JIRA Issues returned from query
    def fetch_issues(jql)
      client.Issue.jql(jql)
    end

    # NOTE: Prefer this syntax here as it's cleaner
    # rubocop:disable Style/RescueEnsureAlignment
    def fetch_project(key)
      client.Project.find(key)
      rescue
        log.error('JIRA HTTPError')
        nil
    end
    # rubocop:enable Style/RescueEnsureAlignment

    # NOTE: Not breaking this function out just yet.
    # rubocop:disable Metrics/AbcSize
    def format_issue(issue)
      t(config.format == 'one-line' ? 'issue.oneline' : 'issue.details',
        key: issue.key,
        summary: issue.summary,
        status: issue.status.name,
        assigned: optional_issue_property('unassigned') { issue.assignee.displayName },
        fixVersion: optional_issue_property('none') { issue.fixVersions.first['name'] },
        priority: optional_issue_property('none') { issue.priority.name },
        url: format_issue_link(issue.key))
    end
    # rubocop:enable Metrics/AbcSize

    # Enumerate issues returned from JQL query and format for response
    #
    # @param [Type Array] issues 1-m issues returned from JQL query
    # @return [Type Array<String>] formatted issues for display to user
    def format_issues(issues)
      results = [t('myissues.info')]
      results.concat(issues.map { |issue| format_issue(issue) })
    end

    def format_issue_link(key)
      "#{config.site}#{config.context}/browse/#{key}"
    end

    def create_issue(project, subject, summary)
      project = fetch_project(project)
      return nil unless project
      issue = client.Issue.build
      issue.save(fields: { subject: subject,
                           summary: summary,
                           project: { id: project.id } })
      issue.fetch
      issue
    end

    # Attempt to retrieve optional JIRA issue property value via a provided block.
    # JIRA properties such as assignee and priority may not exist.
    # In that case, the fallback will be used.
    #
    # @param [Type String] fallback A String value to use if the JIRA property value doesn't exist
    # @return [Type String] fallback or returned value from yield block
    def optional_issue_property(fallback = '')
      yield
    rescue
      fallback
    end
  end
end
