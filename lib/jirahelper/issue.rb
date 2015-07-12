# Helper functions for lita-jira
module JiraHelper
  # Issues
  module Issue
    def fetch_issue(key)
      client.Issue.find(key)
      rescue
        log.error('JIRA HTTPError')
        nil
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
    # @return [Type] fallback or returned value from yield block
    def optional_issue_property(fallback = '')
      yield
    rescue
      fallback
    end
  end
end
