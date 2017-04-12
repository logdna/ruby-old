<p align="center">
  <a href="https://app.logdna.com">
    <img height="95" width="201" src="https://raw.githubusercontent.com/logdna/artwork/master/logo%2Bruby.png">
  </a>
  <p align="center">Ruby gem for logging to <a href="https://app.logdna.com">LogDNA</a></p>
</p>

---

* **[Overview](#overview)**
* **[Installation](#installation)**
* **[API](#api)**
* **[Development](#development)**
* **[Contributing](#contributing)**
* **[License](#license)**

# Overview

This gem contains LogDNA::RubyLogger, an extension to the logger from Ruby's standard library.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'logdna'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logdna

# Quick Setup

After installation, call

    logger = LogDNA::RubyLogger.new(your_api_key, hostname)

to set up the logger.

To send logs, use exactly like the logger from the Ruby standard library. For example:

    require 'logdna'

    logger = LogDNA::RubyLogger.new(your_api_key, hostname)
    logger.level = Logger::WARN

    logger.debug("Created logger")
    logger.info("Program started")
    logger.warn("Nothing to do!")

    path = "a_non_existent_file"

    begin
      File.foreach(path) do |line|
        unless line =~ /^(\w+) = (.*)$/
          logger.error("Line in wrong format: #{line.chomp}")
        end
      end
    rescue => err
      logger.fatal("Caught exception; exiting")
      logger.fatal(err)
    end

# API

## ::new(api_key, hostname, options = {})

Instantiates a new instance of the class it is called on. api_key and hostname are required.

Options:
* logdev: The log device. This is a filename (String) or IO object (e.g. STDOUT, STDERR, an open file). Default: STDOUT.
* mac: MAC address. Default: nil.
* ip: IP address. Default: nil.
* default_app: Set a default app for this instance of the logger. Note that this can be overwritten by the progname below on the line level, as the app is a line attribute.
* environment: Alias for default_app.

__Make sure that the following options are numbers if you supply them. We are not responsible for any type errors if you enter non-numerical values for these options.__

* shift_age: Number of old log files to keep, or frequency of rotation (daily, weekly, or monthly). Default: 7.
* shift_size: Maximum logfile size (only applies when shift_age is a number). Default: 1,048,576
* buffer_max_size: Maximum number of lines in buffer. Default: 10
* buffer_timeout: Frequency of posting requests to LogDNA. Default: 10 (seconds)

## \#add(severity, message=nil, progname=nil) {...}

Log a message if the given severity is high enough and post it to the LogDNA ingester. This is the generic logging method. Users will be more inclined to use debug, info, warn, error, and fatal (which all call \#add), as [described in the Ruby Logger documentation](https://ruby-doc.org/stdlib-2.3.0/libdoc/logger/rdoc/Logger.html). Note that these methods take a source as the argument and a block which returns a message. It returns the http response.

## \#close_http

Close the HTTP connection to LogDNA's ingester.

## \#reopen_http

Open another HTTP connection to LogDNA's ingester if the connection is already closed.

## \#<<(message)

Dump given message to the log device without any formatting, then posts it to the LogDNA ingester. If no log device exists, return nil.

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/logdna/ruby.

# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

