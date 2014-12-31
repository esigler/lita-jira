require 'spec_helper'

describe Lita::Handlers::Jira, lita_handler: true do
  let(:open_issue) do
    r = double
    expect(r).to receive_message_chain('Issue.find') {
      double(summary: 'Some summary text',
             assignee: double(displayName: 'A Person'),
             priority: double(name: 'P0'),
             status: double(name: 'In Progress'),
             key: 'XYZ-987')
    }
    r
  end

  let(:failed_find) do
    r = double
    expect(r).to receive_message_chain('Issue.find').and_throw(JIRA::HTTPError)
    r
  end

  it do
    is_expected.to route_command('jira ABC-123')
    is_expected.to route_command('jira details ABC-123')
  end

  describe '#summary' do
    it 'with valid issue ID shows summary' do
      grab_request(open_issue)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text')
    end

    it 'without valid issue ID shows an error' do
      grab_request(failed_find)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#details' do
    it 'with valid issue ID shows details' do
      grab_request(open_issue)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text, assigned to: ' \
                                 'A Person, priority: P0, status: In Progress')
    end

    it 'without valid issue ID shows an error' do
      grab_request(failed_find)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end
end
