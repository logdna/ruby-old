require 'logger'
require 'faraday'
require_relative '../logdna.rb'

module LogDNA
  class RubyLogger < ::Logger
    include LogDNA

    def initialize(api_key, hostname, options = {})
      Faraday.default_adapter = :net_http_persistent
      @conn = Faraday::Connection.new @log_domain
      opts = fill_opts_with_defaults(options)
      super(opts[:logdev], opts[:shift_age], opts[:shift_size])
      set_ivars(api_key, hostname, options)
    end

    def <<(msg)
      super
      post_to_logdna(msg)
    end
  end
end
