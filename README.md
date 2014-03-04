# lita-jira

**lita-jira** is a handler for [Lita](https://github.com/jimmycuadra/lita), to interact with a JIRA issue tracker.

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

```
Lita jira <issue ID>         # Shows summary for <issue ID>
Lita jira <issue ID> details # Shows detailed information for <issue ID>
```

## License

[MIT](http://opensource.org/licenses/MIT)
