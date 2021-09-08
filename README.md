# UppityRobot

Command line wrapper for the UptimeRobot API (wrapper).

## Installation

Requirements:

- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/)

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
uppityrobot exec getAlertContacts | jq . # pretty formatted using jq
uppityrobot exec getMonitors
```

### Monitors

```bash
uppityrobot monitors --help
uppityrobot m --help # `m` can be used if preferred

# LIST
uppityrobot monitors list # all monitors
uppityrobot monitors list --csv ~/monitors.csv # output to terminal (json) and save as csv
uppityrobot monitors list --search aspace # search within friendly_name and url
uppityrobot monitors list --filter '{"friendly_name": "^aspace-"}' # monitors matching regex
uppityrobot monitors list --filter '{"friendly_name": "^aspace-"}' --csv ~/aspace.csv
# filter operates on the response data so can be combined with search (and csv)
uppityrobot monitors list --search aspace --filter '{"status": 0}' # technically a regex: ^0$'

# TODO
uppityrobot monitors create --name archivesspace --url https://staff.archivesspace.edu --contacts 123,456

uppityrobot monitors delete --id 1
uppityrobot monitors delete --name archivesspace

uppityrobot monitors get --id 1
uppityrobot monitors get --name archivesspace

uppityrobot monitors pause --id 1
uppityrobot monitors pause --name archivesspace

uppityrobot monitors start --id 1
uppityrobot monitors start --name archivesspace

uppityrobot monitors update --help
uppityrobot monitors update --csv ~/aspace.csv # update monitors from csv
uppityrobot monitors update --params '{"id": 1, "friendly_name": "newName"}' # update monitor using params
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

## Release

To release a new version:

- Update the version number in `version.rb`
- Run `bundle exec rake release`

This:

- Creates a git tag for the version
- Pushes git commits and the created tag
- Pushes the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/uppityrobot.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
