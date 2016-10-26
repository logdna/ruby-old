# The Official LogDNA Ruby Gem!

## Overview

This gem contains LogDNA::RubyLogger, an extension to the logger from Ruby's standard library, as well as LogDNA::RailsLogger, which inherits from ActiveSupport::Logger from Rails. ActiveSupport is not formally listed as a dependency for this gem because the RubyLogger can be used without it, but you are warned that **LogDNA::RailsLogger depends on ActiveSupport**. Of course, this shouldn't be an issue as long as you're using the RailsLogger only with Rails projects, since ActiveSupport is (obviously) a dependency of Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logdna'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logdna

## API

### Shared by LogDNA::RubyLogger and LogDNA::RailsLogger

#### ::new(api_key, hostname, options = {})

Instantiates a new instance of the class it is called on. api_key and hostname are required.

Options:
* logdev: The log device. This is a filename (String) or IO object (e.g. STDOUT, STDERR, an open file). Default: STDOUT.
* shift_age: Number of old log files to keep, or frequency of rotation (daily, weekly, or monthly). Default: 7.
* shift_size: Maximum logfile size (only applies when shift_age is a number). Default: 1,048,576
* mac: MAC address. Default: nil.
* ip: IP address. Default: nil.

#### \#add

Log a message if the given severity is high enough. This is the generic logging method. Users will be more inclined to use debug, info, warn, error, and fatal, as [described in the Ruby Logger documentation](https://ruby-doc.org/stdlib-2.3.0/libdoc/logger/rdoc/Logger.html). Note that these methods take a source as the argument and a block which returns a message.

#### \#close

Close the logging device and the HTTP connection to LogDNA's ingester.

#### \#reopen(logdev)

Reopen the logging device and open another HTTP connection to LogDNA's ingester.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports are welcome on GitHub at https://github.com/logdna/logdna_ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

