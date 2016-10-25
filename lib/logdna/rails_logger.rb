require 'active_support/logger'
require 'faraday'
require_relative '../logdna.rb'

module LogDNA
  class RailsLogger < ActiveSupport::Logger
    include LogDNA

    def initialize(api_key, hostname, options = {})
      Faraday.default_adapter = :net_http_persistent
      @conn = Faraday::Connection.new @log_domain
      opts = fill_opts_with_defaults(options)
      super([opts[:logdev], opts[:shift_age], opts[:shift_size]]) # wtf rails
      set_ivars(api_key, hostname, options)
    end
  end
end
