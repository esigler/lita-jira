# Helper functions for lita-jira
module JiraHelper
  # Regular expressions
  module Regex
    PROJECT_PATTERN = /([a-zA-Z0-9]{1,10})/
    ISSUE_PATTERN   = /(?<issue>#{PROJECT_PATTERN}-[0-9]{1,5}+)/
    EMAIL_PATTERN   = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end
end
