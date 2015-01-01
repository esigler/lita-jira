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
        assigned: issue.assignee.displayName,
        priority: issue.priority.name,
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
  end
end
