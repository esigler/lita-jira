# lita-jira

[![Build Status](https://img.shields.io/travis/esigler/lita-jira/master.svg)](https://travis-ci.org/esigler/lita-jira)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/lita-jira.svg)](https://rubygems.org/gems/lita-jira)
[![Coveralls Coverage](https://img.shields.io/coveralls/esigler/lita-jira/master.svg)](https://coveralls.io/r/esigler/lita-jira)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-jira.svg)](https://codeclimate.com/github/esigler/lita-jira)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-jira.svg)](https://gemnasium.com/esigler/lita-jira)

A [JIRA](https://www.atlassian.com/software/jira) plugin for [Lita](https://github.com/jimmycuadra/lita).

## Installation

Add lita-jira to your Lita instance's Gemfile:

``` ruby
gem "lita-jira"
```

## Configuration

Add the following variables to your lita config file:

```
config.handlers.jira.username = 'your_jira_username'
config.handlers.jira.password = 'a_password'
config.handlers.jira.site     = 'https://your.jira.instance.example.com/'
config.handlers.jira.context  = '' # If your instance is in a /subdirectory, put that here
```

## Usage

### Shortcuts

```
todo <summary> - Creates an issue with your default priority and project settings, assigned to yourself
```

### Issues

```
jira issue assignee <issue ID>                 - Shows assignee of <issue ID>
jira issue assignee <issue ID> <email address> - Sets <email address> as the assignee
jira issue attachments <issue ID>              - Shows all attachments for <issue ID>
jira issue attachments <issue ID> <URL>        - Adds <URL> as an attachment on <issue ID>
jira issue comments <issue ID>                 - Shows all comments for <issue ID>
jira issue comments <issue ID> <text>          - Adds <text> as a comment on <issue ID>
jira issue details <issue ID>                  - Shows all details for <issue ID>
jira issue issuetype <issue ID>                - Shows the Issue Type of <issue ID>
jira issue issuetype <issue ID> <issuetype ID> - Sets the Issue Type of <issue ID> to <issuetype ID>
jira issue new <project ID> <args>             - Creates a new issue in <project ID> with <args> (args is any name:"value" pair, such as summary:"Some text")
jira issue notify <issue ID>                   - Shows who is notified when <issue ID> is changed
jira issue notify <issue ID> <email address>   - Adds <email address> to notification list for <issue ID>
jira issue priority <issue ID>                 - Shows priority of <issue ID>
jira issue priority <issue ID> <new priority>  - Sets <new priority> of <issue ID>
jira issue summary <issue ID>                  - Shows summary of <issue ID>
jira issue summary <issue ID> <text>           - Sets summary of <issue ID> to <text>
jira issue watchers <issue ID>                 - Shows watchers of <issue ID>
jira issue watchers <issue ID> <email address> - Adds <email address> to watchers list for <issue ID>
```

### Issue Types

```
jira issuetype list <project ID> - List all issuetypes for <project ID>
```

### Search

```
jira search "<text>"              - Search for <text> across all of JIRA
jira search <project ID> "<text>" - Search for <text> within the scope of <project ID>
```

### Misc

```
jira identify <email address>     - Associate your chat user with your email address
jira forget                       - Remove your chat user / email association
jira whoami                       - Show your chat user / email association
jira default project <project ID> - Set your default project ID to <project ID>
jira default priority <priority>  - Set your default priority to <priority>
```

## License

[MIT](http://opensource.org/licenses/MIT)
