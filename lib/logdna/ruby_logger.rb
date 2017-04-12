require 'logger'
require 'http'

module LogDNA
  class RubyLogger < ::Logger
    include LogDNA

    attr_reader :open
    attr_accessor :api_key, :host, :default_app, :ip, :mac

    def initialize(api_key, hostname, options = {})
      @conn = HTTP.persistent LogDNA::INGESTER_DOMAIN
      opts = fill_opts_with_defaults(options)
      super(opts[:logdev], opts[:shift_age], opts[:shift_size])
      set_ivars(api_key, hostname, options)
    end

    def <<(msg)
      super
      push_to_buffer(msg)
    end
  end
end
