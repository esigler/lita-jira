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
config.handlers.jira.issue_pattern = 'FOO-\d+' # (optional) it will make lita comment each time an issue is mentioned
```

## Usage

### Shortcuts

```
todo <project> "<subject>" ["<summary>"] - Creates an issue in <project> with <subject> and optionally <summary>
```

```
jira <issue>                             - Shows a short summary <issue>
jira details <issue>                     - Shows all details about <issue>
jira comment on <issue> <comment text>   - Adds <comment text> to <issue>
```

### Misc

```
jira identify <email address> - Associate your chat user with your email address
jira forget                   - Remove your chat user / email association
jira whoami                   - Show your chat user / email association
```

## License

[MIT](http://opensource.org/licenses/MIT)
