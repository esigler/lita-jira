require 'spec_helper'

describe Lita::Handlers::Jira, lita_handler: true do
  let(:open_issue) do
    double(summary: 'Some summary text',
           assignee: double(displayName: 'A Person'),
           priority: double(name: 'P0'),
           status: double(name: 'In Progress'),
           key: 'XYZ-987')
  end

  def grab_issue_request(key, issue)
    allow_any_instance_of(Lita::Handlers::Jira).to \
      receive(:fetch_issue).with(key).and_return(issue)
  end

  it { routes_command('todo some text').to(:todo) }
  it { routes_command('jira issue assignee ABC-123').to(:issue_assignee_list) }
  it { routes_command('jira issue assignee ABC-123 foo@example.com').to(:issue_assignee_set) }
  it { routes_command('jira issue attachments ABC-123').to(:issue_attachments_list) }
  it { routes_command('jira issue attachments ABC-123 http://example.com').to(:issue_attachments_set) }
  it { routes_command('jira issue comments ABC-123').to(:issue_comments_list) }
  it { routes_command('jira issue comments ABC-123 Some text').to(:issue_comments_add) }
  it { routes_command('jira issue details ABC-123').to(:issue_details) }
  it { routes_command('jira issue issuetype ABC-123').to(:issue_issuetype_list) }
  it { routes_command('jira issue issuetype ABC-123 4').to(:issue_issuetype_set) }
  it { routes_command('jira issue new ABC some:thing').to(:issue_new) }
  it { routes_command('jira issue notify ABC-123').to(:issue_notify_list) }
  it { routes_command('jira issue notify ABC-123 foo@example.com').to(:issue_notify_set) }
  it { routes_command('jira issue priority ABC-123').to(:issue_priority_list) }
  it { routes_command('jira issue priority ABC-123 9').to(:issue_priority_set) }
  it { routes_command('jira issue summary ABC-123').to(:issue_summary_list) }
  it { routes_command('jira issue summary ABC-123 Some text!').to(:issue_summary_set) }
  it { routes_command('jira issue watchers ABC-123').to(:issue_watchers_list) }
  it { routes_command('jira issue watchers ABC-123 foo@example.com').to(:issue_watchers_set) }
  it { routes_command('jira issuetype list ABC').to(:issuetype_list) }
  it { routes_command('jira search Some text').to(:search_full) }
  it { routes_command('jira search ABC Some text').to(:search_project) }
  it { routes_command('jira identify foo@example.com').to(:identify) }
  it { routes_command('jira forget').to(:forget) }
  it { routes_command('jira whoami').to(:whoami) }
  it { routes_command('jira default project ABC').to(:default_project) }
  it { routes_command('jira default priority 9').to(:default_priority) }

  describe '.default_config' do
    it 'sets username to nil' do
      expect(Lita.config.handlers.jira.username).to be_nil
    end

    it 'sets password to nil' do
      expect(Lita.config.handlers.jira.password).to be_nil
    end

    it 'sets site to nil' do
      expect(Lita.config.handlers.jira.site).to be_nil
    end

    it 'sets context to nil' do
      expect(Lita.config.handlers.jira.context).to be_nil
    end
  end

  describe '#issue_summary' do
    it 'with valid issue ID shows summary' do
      grab_issue_request('XYZ-987', open_issue)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text')
    end

    it 'without valid issue ID shows an error' do
      grab_issue_request('XYZ-987', nil)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#issue_details' do
    it 'with valid issue ID shows details' do
      grab_issue_request('XYZ-987', open_issue)
      send_command('jira XYZ-987 details')
      expect(replies.last).to eq('XYZ-987: Some summary text, assigned to: ' \
                                 'A Person, priority: P0, status: In Progress')
    end

    it 'without valid issue ID shows an error' do
      grab_issue_request('XYZ-987', nil)
      send_command('jira XYZ-987 details')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#todo' do
  end

  describe '#issue_assignee_list' do
  end

  describe '#issue_assignee_set' do
  end

  describe '#issue_attachments_list' do
  end

  describe '#issue_attachments_set' do
  end

  describe '#issue_comments_list' do
  end

  describe '#issue_comments_add' do
  end

  describe '#issue_details' do
  end

  describe '#issue_issuetype_list' do
  end

  describe '#issue_issuetype_set' do
  end

  describe '#issue_new' do
  end

  describe '#issue_notify_list' do
  end

  describe '#issue_notify_set' do
  end

  describe '#issue_priority_list' do
  end

  describe '#issue_priority_set' do
  end

  describe '#issue_summary_list' do
  end

  describe '#issue_summary_set' do
  end

  describe '#issue_watchers_list' do
  end

  describe '#issue_watchers_set' do
  end

  describe '#issuetype_list' do
  end

  describe '#search_full' do
  end

  describe '#search_project' do
  end

  describe '#identify' do
  end

  describe '#forget' do
  end

  describe '#whoami' do
  end

  describe '#default_project' do
  end

  describe '#default_priority' do
  end
end
