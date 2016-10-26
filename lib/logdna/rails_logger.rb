require 'active_support/logger'
require 'http'

module LogDNA
  class RailsLogger < ActiveSupport::Logger
    include LogDNA

    def initialize(api_key, hostname, options = {})
      @conn = HTTP.persistent LogDNA::INGESTER_DOMAIN
      opts = fill_opts_with_defaults(options)
      super(opts[:logdev], opts[:shift_age], opts[:shift_size])
      set_ivars(api_key, hostname, options)
    end
  end
end
