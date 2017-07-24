#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'logdna'

logger = LogDNA::RubyLogger.new('d8e14421399a44a9a35dfc49c7f5f0aa',
                                     'RUBYTEST',
                                     default_app: 'RUBS',
                                     buffer_max_size: 1)

logger.debug("Created logger")
logger.info("Program started \x9C")
logger.warn({'name' => 'Zed', 'age' => 39, 'height' => 6 * 12 + 2})
logger.debug("")
logger << "another"

def fail
    begin
        puts blah
    rescue
        raise Exception.new('Test Error')
    end
end

fail

logger.debug("Created logger")
logger.info("Program started \x9C")
