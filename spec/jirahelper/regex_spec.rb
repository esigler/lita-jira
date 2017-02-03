require 'spec_helper'

describe JiraHelper::Regex do

  PROJECT_PATTERN = JiraHelper::Regex::PROJECT_PATTERN
  SUBJECT_PATTERN = JiraHelper::Regex::SUBJECT_PATTERN
  SUMMARY_PATTERN = JiraHelper::Regex::SUMMARY_PATTERN

  #
  # route(
  #        /^todo\s#{PROJECT_PATTERN}\s#{SUBJECT_PATTERN}(\s#{SUMMARY_PATTERN})?$/,
  #
  let(:regex) {Regexp.new(/^todo\s#{PROJECT_PATTERN}\s#{SUBJECT_PATTERN}(\s#{SUMMARY_PATTERN})?$/)}

  it 'double quotes around subject and summary' do
    subject = "Any subject"
    summary = "Any summary"
    project = 'PRJ'
    message = %(todo #{project} "#{subject}" "#{summary}")
    match = message.match(regex)
    expect(match['project']).to eq(project)
    expect(match['summary']).to eq(summary)
    expect(match['subject']).to eq(subject)
  end

end
