require 'spec_helper'

describe Lita::Handlers::JiraUtility, lita_handler: true do
  it do
    is_expected.to route_command('jira identify user@example.com').to(:identify)
    is_expected.to route_command('jira forget').to(:forget)
    is_expected.to route_command('jira whoami').to(:whoami)
  end

  describe '#identify' do
    it 'remembers the user if they do not already have an email address stored' do
      send_command('jira identify user@example.com')
      expect(replies.last).to eq('You have been identified as user@example.com to JIRA')
    end

    it 'warns the user if they have already stored an email address' do
      send_command('jira identify user@example.com')
      send_command('jira identify otheruser@example.com')
      expect(replies.last).to eq('You are already identified as user@example.com')
    end
  end

  describe '#forget' do
    it 'forgets the user if they have an email address stored' do
      send_command('jira identify user@example.com')
      send_command('jira forget')
      expect(replies.last).to eq('You have been de-identified from JIRA')
    end

    it 'warns the user if they did not have a stored email address' do
      send_command('jira forget')
      expect(replies.last).to eq('You do not have an email address on record')
    end
  end

  describe '#whoami' do
    it 'shows the current stored email address if one exists' do
      send_command('jira identify user@example.com')
      send_command('jira whoami')
      expect(replies.last).to eq('You are identified with JIRA as user@example.com')
    end

    it 'warns the user if there is no stored address' do
      send_command('jira whoami')
      expect(replies.last).to eq('You do not have an email address on record')
    end
  end
end
