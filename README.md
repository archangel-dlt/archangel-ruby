# Archangel

[![Build Status](http://img.shields.io/travis/archangel-dlt/archangel-ruby.svg?style=flat-square)](https://travis-ci.org/archangel-dlt/archangel-ruby)
[![Dependency Status](http://img.shields.io/gemnasium/archangel-dlt/archangel-ruby.svg?style=flat-square)](https://gemnasium.com/archangel-dlt/archangel-ruby)
[![Code Climate](http://img.shields.io/codeclimate/github/archangel-dlt/archangel-ruby.svg?style=flat-square)](https://codeclimate.com/github/archangel-dlt/archangel-ruby)
[![Gem Version](http://img.shields.io/gem/v/archangel.svg?style=flat-square)](https://rubygems.org/gems/archangel)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://archangel-dlt.mit-license.org)

A Ruby client library and command-line interface for the Archangel DLT system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'archangel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install archangel

## Usage

You can store and fetch data using the command-line client:

``` sh
bundle exec archangel store {id} {payload}
```

``` sh
bundle exec archangel fetch {id}
```

Currently this will store the payload string into Archangel (based on the ID and current time) using the dummy filesystem driver. A simple driver for Guardtime's Catena DB is also available.  Future versions will support richer data and more backend drivers.

``` sh
Commands:
  archangel store ID PAYLOAD  # stores PAYLOAD for ID at the current time
  archangel fetch ID          # retrieves the PAYLOAD previously stored with ID

Options:
  [--driver=DRIVER]      # Backend driver to use [file|guardtime]. Defaults to file
  [--username=USERNAME]  # Guardtime username
  [--password=PASSWORD]  # Guardtime password
  [--dir=DIR]            # File storage root directory
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/archangel-dlt/archangel-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Archangel project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/archangel/blob/master/CODE_OF_CONDUCT.md).
