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
                    fixVersions: [{ 'name' => 'Sprint 2' }],
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
                     fixVersions: [{ 'name' => 'Sprint 2' }],
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
    is_expected.to route_command('jira point ABC-123 as 2').to(:point)
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

    it 'displays the correct URL when config.context is set' do
      registry.config.handlers.jira.context = '/myjira'
      grab_request(valid_client)
      send_command('jira details XYZ-987')
      expect(replies.last).to eq("[XYZ-987] Some summary text\nStatus: In Progress, assigned to: A Person, fixVersion: Sprint 2, priority: P0\nhttp://jira.local/myjira/browse/XYZ-987")
      registry.config.handlers.jira.context = ''
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

  describe '#point' do
    it 'updates the issue with a story point value' do
      registry.config.handlers.jira.points_field = 'customfield_10004'
      expect(valid_client).to receive(:save).with({fields: { customfield_10004: 5 }})
      grab_request(valid_client)
      send_command('jira point XYZ-987 as 5')
      expect(replies.last).to eq('Added a point estimation of 5 to XYZ-987')
    end

    it 'warns the user when the issue is not valid' do
      registry.config.handlers.jira.points_field = 'customfield_10004'
      grab_request(failed_find_issue)
      send_command('jira point XYZ-987 as 5')
      expect(replies.last).to eq('Error fetching JIRA issue')
    end

    it 'warns the user when the config points_field is not defined' do
      registry.config.handlers.jira.points_field = nil
      grab_request(valid_client)
      send_command('jira point XYZ-987 as 5')
      expect(replies.last).to eq('You must define `points_field` in your lita_config')
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

  describe '#ambient' do
    it 'does not show details for a detected issue by default'

    context 'when enabled in config' do
      before(:each) do
        registry.config.handlers.jira.ambient = true
        grab_request(valid_client)
      end

      it 'shows details for a detected issue in a message' do
        send_message('XYZ-987')
        send_message('foo XYZ-987 bar')
        send_message('foo XYZ-987?')
        expect(replies.size).to eq(3)
      end

      it 'does not show details for a detected issue in a command' do
        send_command('foo XYZ-987 bar')
        expect(replies.size).to eq(0)
      end

      it 'does not show details for a issue in a URL-ish context' do
        send_message('http://www.example.com/XYZ-987')
        send_message('http://www.example.com/XYZ-987.html')
        send_message('http://www.example.com/someother-XYZ-987.html')
        send_message('TIL http://ruby-doc.org/core-2.3.0/Enumerable.html#method-i-each_slice')
        expect(replies.size).to eq(0)
      end

      context 'and an ignore list is defined' do
        before(:each) do
          @user1 = Lita::User.create('U1', name: 'User 1', mention_name: 'user1')
          @user2 = Lita::User.create('U2', name: 'User 2', mention_name: 'user2')
          @user3 = Lita::User.create('U3', name: 'User 3', mention_name: 'user3')
          @user4 = Lita::User.create('U4', name: 'User 4', mention_name: 'user4')
          registry.config.handlers.jira.ignore = ['User 2', 'U3', 'user4']
        end

        it 'shows details for a detected issue sent by a user absent from the list' do
          send_message('foo XYZ-987 bar', as: @user1)
          expect(replies.last).to eq("[XYZ-987] Some summary text\nStatus: In Progress, assigned to: A Person, fixVersion: Sprint 2, priority: P0\nhttp://jira.local/browse/XYZ-987")
        end

        it 'does not show details for a detected issue sent by a user whose name is on the list' do
          send_message('foo XYZ-987 bar', as: @user2)
          expect(replies.size).to eq(0)
        end

        it 'does not show details for a detected issue sent by a user whose ID is on the list' do
          send_message('foo XYZ-987 bar', as: @user3)
          expect(replies.size).to eq(0)
        end

        it 'does not show details for a detected issue sent by a user whose mention name is on the list' do
          send_message('foo XYZ-987 bar', as: @user4)
          expect(replies.size).to eq(0)
        end
      end

      context 'and a room list is defined' do
        def send_room_message(body, room)
          robot.receive(Lita::Message.new(robot, body, Lita::Source.new(user: user, room: room)))
        end

        before(:each) do
          @room1 = 'Room1'
          @room2 = 'Room2'
          registry.config.handlers.jira.rooms = [@room1]
        end

        it 'shows details for a detected issue sent in a room on the list' do
          send_room_message('foo XYZ-987 bar', @room1)
          expect(replies.last).to eq("[XYZ-987] Some summary text\nStatus: In Progress, assigned to: A Person, fixVersion: Sprint 2, priority: P0\nhttp://jira.local/browse/XYZ-987")
        end

        it 'does not show details for a detected issue sent in a room absent from the list' do
          send_room_message('foo XYZ-987 bar', @room2)
          expect(replies.size).to eq(0)
        end
      end
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
        expect(replies[-3..-1]).to eq([
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
