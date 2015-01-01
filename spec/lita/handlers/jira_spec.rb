require 'spec_helper'

describe Lita::Handlers::Jira, lita_handler: true do
  let(:saved_issue) do
    result = double(summary: 'Some summary text',
                    assignee: double(displayName: 'A Person'),
                    priority: double(name: 'P0'),
                    status: double(name: 'In Progress'),
                    key: 'XYZ-987')
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
    issue
  end

  let(:failed_find_issue) do
    r = double
    expect(r).to receive_message_chain('Issue.find').and_throw(JIRA::HTTPError)
    r
  end

  let(:failed_find_project) do
    r = double
    expect(r).to receive_message_chain('Project.find').and_throw(JIRA::HTTPError)
    r
  end

  it do
    is_expected.to route_command('jira ABC-123').to(:summary)
    is_expected.to route_command('jira details ABC-123').to(:details)
    is_expected.to route_command('jira comment on ABC-123 "You just need a cat"').to(:comment)
    is_expected.to route_command('todo ABC "summary text"').to(:todo)
    is_expected.to route_command('todo ABC "summary text" "subject text"').to(:todo)
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
      expect(replies.last).to eq('XYZ-987: Some summary text, assigned to: ' \
                                 'A Person, priority: P0, status: In Progress')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find_issue)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
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
end
