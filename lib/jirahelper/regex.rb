# frozen_string_literal: true

# Helper functions for lita-jira
module JiraHelper
  # Regular expressions
  module Regex
    COMMENT_PATTERN = /\"(?<comment>.+)\"/
    SUBJECT_PATTERN = /\"(?<subject>.+?)\"/
    SUMMARY_PATTERN = /\"(?<summary>.+?)\"/
    PROJECT_PATTERN = /(?<project>[a-zA-Z0-9]{1,10})/
    ISSUE_PATTERN   = /(?<issue>#{PROJECT_PATTERN}-[0-9]{1,5}+)/
    EMAIL_PATTERN   = /(?<email>[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)/i
    AMBIENT_PATTERN = /(\s|^)#{ISSUE_PATTERN}/
    POINTS_PATTERN  = /(?<points>\d{1,2})/
  end
end
