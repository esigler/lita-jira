# Helper functions for lita-jira
module JiraHelper
  # Issues
  module Issue
    def fetch_issue(key, expected=true)
      client.Issue.find(key)
      rescue
        log.error('JIRA HTTPError') if expected
        nil
    end

    # Leverage the jira-ruby Issue.jql search feature
    #
    # @param [Type String] jql Valid JQL query
    # @return [Type Array] 0-m JIRA Issues returned from query
    def fetch_issues(jql)
      client.Issue.jql(jql)
    end

    def fetch_project(key)
      client.Project.find(key)
      rescue
        log.error('JIRA HTTPError')
        nil
    end

    def format_issue(issue)
      t('issue.details',
        key: issue.key,
        summary: issue.summary,
        assigned: optional_issue_property('unassigned') { issue.assignee.displayName },
        priority: optional_issue_property('none') { issue.priority.name },
        status: issue.status.name)
    end

    # Enumerate issues returned from JQL query and format for response
    #
    # @param [Type Array] issues 1-m issues returned from JQL query
    # @return [Type Array<String>] formatted issues for display to user
    def format_issues(issues)
      results = [t('myissues.info')]
      results.concat(issues.map { |issue| format_issue(issue) })
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
