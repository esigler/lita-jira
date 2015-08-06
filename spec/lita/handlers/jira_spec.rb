require 'spec_helper'

describe Lita::Handlers::Jira, lita_handler: true do
  before do
    registry.config.handlers.jira.site = 'http://jira.local'
  end

  let(:saved_issue) do
    result = double(summary: 'Some summary text',
                    assignee: double(displayName: 'A Person'),
                    priority: double(name: 'P0'),
                    status: double(name: 'In Progress'),
                    fixVersions: [{'name' => 'Sprint 2'}],
                    key: 'XYZ-987')
    allow(result).to receive('save') { true }
    allow(result).to receive('fetch') { true }
    result
  end

  let(:saved_issue_with_fewer_details) do
    result = double(summary: 'Some summary text',
                    status: double(name: 'In Progress'),
                    fixVersions: [],
                    key: 'XYZ-987')
    allow(result).to receive('assignee').and_raise
    allow(result).to receive('priority').and_raise
    allow(result).to receive('save') { true }
    allow(result).to receive('fetch') { true }
    result
  end

  let(:valid_search_results) do
    result = [double(summary: 'Some summary text',
                     assignee: double(displayName: 'A Person'),
                     priority: double(name: 'P0'),
                     status: double(name: 'In Progress'),
                     fixVersions: [{'name' => 'Sprint 2'}],
                     key: 'XYZ-987'),
              double(summary: 'Some summary text 2',
                     assignee: double(displayName: 'A Person 2'),
                     priority: double(name: 'P1'),
                     status: double(name: 'In Progress 2'),
                     fixVersions: [],
                     key: 'XYZ-988')]
    allow(result).to receive('save') { true }
    allow(result).to receive('fetch') { true }
    result
  end

  let(:saved_project) do
    double(key: 'XYZ',
           id: 1)
  end

  let(:valid_client) do
    issue = double
    allow(issue).to receive_message_chain('Issue.find') { saved_issue }
    allow(issue).to receive_message_chain('Issue.find.comments.build.save!') { saved_issue }
    allow(issue).to receive_message_chain('Issue.build') { saved_issue }
    allow(issue).to receive_message_chain('Project.find') { saved_project }
    allow(issue).to receive_message_chain('Issue.jql') { valid_search_results }
    issue
  end

  let(:client_with_fewer_details) do
    issue = double
    allow(issue).to receive_message_chain('Issue.find') { saved_issue_with_fewer_details }
    issue
  end

  let(:failed_find_issue) do
    r = double
    expect(r).to receive_message_chain('Issue.find').and_throw(JIRA::HTTPError)
    r
  end

  let(:failed_find_issues) do
    r = double
    expect(r).to receive_message_chain('Issue.jql').and_throw(JIRA::HTTPError)
    r
  end

  let(:failed_find_project) do
    r = double
    expect(r).to receive_message_chain('Project.find').and_throw(JIRA::HTTPError)
    r
  end

  let(:empty_search_result) do
    r = double
    expect(r).to receive_message_chain('Issue.jql') { [] }
    r
  end

  it do
    is_expected.to route_command('jira ABC-123').to(:summary)
    is_expected.to route_command('jira details ABC-123').to(:details)
    is_expected.to route_command('jira comment on ABC-123 "You just need a cat"').to(:comment)
    is_expected.to route_command('todo ABC "summary text"').to(:todo)
    is_expected.to route_command('todo ABC "summary text" "subject text"').to(:todo)
    is_expected.to route_command('jira myissues').to(:myissues)
  end

  describe '#summary' do
    it 'shows summary with a valid issue' do
      grab_request(valid_client)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find_issue)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#details' do
    it 'shows details with a valid issue' do
      grab_request(valid_client)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq("[XYZ-987] Some summary text\nStatus: In Progress, assigned to: A Person, fixVersion: Sprint 2, priority: P0\nhttp://jira.local/browse/XYZ-987")
    end

    it 'shows fewer details when the property is not set' do
      grab_request(client_with_fewer_details)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq("[XYZ-987] Some summary text\nStatus: In Progress, assigned to: unassigned, fixVersion: none, priority: none\nhttp://jira.local/browse/XYZ-987")
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find_issue)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end

    it 'shows details on one line with a valid issue if config.format is one-line' do
      registry.config.handlers.jira.format = 'one-line'
      grab_request(valid_client)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('http://jira.local/browse/XYZ-987 - In Progress, A Person - Some summary text')
      registry.config.handlers.jira.format = 'verbose'
    end
  end

  describe '#comment' do
    it 'updates the comment with a valid issue and comment text' do
      grab_request(valid_client)
      send_command('jira comment on XYZ-987 "Testing"')
      expect(replies.last).to eq('Comment added to XYZ-987')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find_issue)
      send_command('jira comment on XYZ-987 "Testing"')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#todo' do
    it 'creates a new issue if the project is valid and there is a summary' do
      grab_request(valid_client)
      send_command('todo XYZ "Some summary text"')
      expect(replies.last).to eq('Issue XYZ-987 created')
    end

    it 'warns the user when the project is not valid' do
      grab_request(failed_find_project)
      send_command('todo ABC "Some summary text"')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#myissues' do
    before { send_command('jira forget') }
    context 'when not identified' do
      it 'fails when user is not identified' do
        send_command('jira myissues')
        expect(replies.last).to eq('You do not have an email address on record')
      end
    end

    context 'when identified' do
      before { send_command('jira identify user@example.com') }

      it 'shows default response when no results are returned' do
        grab_request(empty_search_result)
        send_command('jira myissues')
        expect(replies.last).to eq('You do not have any assigned issues. Great job!')
      end

      it 'shows results when returned' do
        grab_request(valid_client)
        send_command('jira myissues')
        expect(replies.last).to eq([
          'Here are issues currently assigned to you:',
          "[XYZ-987] Some summary text\nStatus: In Progress, assigned to: A Person, fixVersion: Sprint 2, priority: P0\nhttp://jira.local/browse/XYZ-987",
          "[XYZ-988] Some summary text 2\nStatus: In Progress 2, assigned to: A Person 2, fixVersion: none, priority: P1\nhttp://jira.local/browse/XYZ-988"
        ])
      end

      it 'shows an error when the search fails' do
        grab_request(failed_find_issues)
        send_command('jira myissues')
        expect(replies.last).to eq('Error fetching JIRA issue')
      end
    end
  end
end
