require 'spec_helper'

describe Lita::Handlers::Jira, lita_handler: true do
  let(:basic_issue) do
    double(summary: 'Some summary text',
           assignee: double(displayName: 'A Person'),
           priority: double(name: 'P0'),
           status: double(name: 'In Progress'),
           key: 'XYZ-987')
  end

  let(:open_issue) do
    r = double
    expect(r).to receive_message_chain('Issue.find') { basic_issue }
    r
  end

  let(:failed_find) do
    r = double
    expect(r).to receive_message_chain('Issue.find').and_throw(JIRA::HTTPError)
    r
  end

  let(:comment_issue) do
    r = double
    expect(r).to receive_message_chain('Issue.find') { basic_issue }
    expect(r).to receive_message_chain('Issue.find.comments.build.save!') { basic_issue }
    r
  end

  it do
    is_expected.to route_command('jira ABC-123')
    is_expected.to route_command('jira details ABC-123')
    is_expected.to route_command('jira comment on ABC-123 "You just need a cat"')
  end

  describe '#summary' do
    it 'shows summary with a valid issue' do
      grab_request(open_issue)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find)
      send_command('jira XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#details' do
    it 'shows details with a valid issue' do
      grab_request(open_issue)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('XYZ-987: Some summary text, assigned to: ' \
                                 'A Person, priority: P0, status: In Progress')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end

  describe '#comment' do
    it 'updates the comment with a valid issue and comment text' do
      grab_request(comment_issue)
      send_command('jira comment on XYZ-987 "Testing"')
      expect(replies.last).to eq('Comment added to XYZ-987')
    end

    it 'warns the user when the issue is not valid' do
      grab_request(failed_find)
      send_command('jira comment on XYZ-987 "Testing"')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end
  end
end
