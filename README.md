# UppityRobot

Command line wrapper for the [UptimeRobot API](https://uptimerobot.com/api/) (wrapper).

## Installation

Requirements:

- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/)
- `UPTIMEROBOT_API_KEY` environment variable

```bash
gem install uppityrobot
```

To avoid having to prefix `UPTIMEROBOT_API_KEY` before each command run:

```bash
export UPTIMEROBOT_API_KEY=${key}
```

To persist between terminal sessions add the key to `.bashrc` or equivalent.

## Usage

### Raw API

```bash
uppityrobot exec --help
uppityrobot e --help # `e` can be used if preferred
uppityrobot exec getAlertContacts | jq . # pretty formatted using jq
uppityrobot exec getMonitors
```

### Monitors

```bash
uppityrobot monitors --help
uppityrobot m --help # `m` can be used if preferred
```

Group commands:

```bash
# LIST
uppityrobot monitors list # all monitors
uppityrobot monitors list --csv ~/monitors.csv # output to terminal (json) and save as csv
uppityrobot monitors list --search aspace # search within friendly_name and url
uppityrobot monitors list --filter '{"friendly_name": "^aspace-"}' # monitors matching regex
uppityrobot monitors list --filter '{"friendly_name": "^aspace-"}' --csv ~/aspace.csv
# filter operates on the response data so can be combined with search (and csv)
uppityrobot monitors list --search aspace --filter '{"status": 0}' # technically a regex: ^0$'

# EXEC
uppityrobot monitors exec pause aspace # pause all monitors matching "aspace"
uppityrobot monitors exec start aspace # start all monitors matching "aspace"
uppityrobot monitors exec pause aspace --filter '{"status": 2}' # only pause running monitors
uppityrobot monitors exec start aspace --filter '{"status": 0}' # only start paused monitors

# UPDATE
uppityrobot monitors update --help
uppityrobot monitors update csv ~/aspace.csv # update monitors from csv
uppityrobot monitors update json ~/aspace.json # update monitors from json file
uppityrobot monitors update json '[{"id": 1, "friendly_name": "newName"}]' # rename monitor using json string
```

Individual commands:

```bash
# CREATE
uppityrobot monitors create archivesspace https://staff.archivesspace.edu 123-456

# DELETE
uppityrobot monitors delete id 1
uppityrobot monitors delete name archivesspace
```

## Development

Clone the repository then run:

```bash
# install dependencies
./bin/setup

# interactive console
./bin/console

# run the tests
bundle exec rake # runs all tests and rubocop
bundle exec cucumber features
bundle exec rspec

# install locally
bundle exec rake install
gem uninstall uppityrobot
```

### Console examples

```ruby
client = UppityRobot::Client.new(:getMonitors, {})
client.paginate.each { |r, o, t| puts o; puts r.inspect; }

client = UppityRobot::Client.new(:getMonitors, {search: 'aspace'})
client.filter({'friendly_name' => 'columbia'}).each { |m| puts m.inspect; }
```

## Including UppityRobot tasks in another project

```ruby
require "uppityrobot"
spec = Gem::Specification.find_by_name("uppityrobot")
load File.join(spec.gem_dir, "lib", "uppityrobot", "Rakefile")
```

## Release

```bash
gem install gem-release
# https://github.com/svenfuchs/gem-release#gem-bump
gem bump --version $VERSION --tag
# i.e.
gem bump --version minor --tag --pretend # dryrun
gem bump --version minor --tag # do it for real

bundle
git commit --amend # needed via Rakefile
# now push & release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/uppityrobot.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
