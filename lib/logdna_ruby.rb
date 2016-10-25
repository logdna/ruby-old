require 'json'
require 'logger'
require 'logdna_ruby/version'
require 'faraday'

module LogdnaRuby
  class Logger < ::Logger
    Faraday.default_adapter = :net_http_persistent
    @conn = Faraday::Connection.new 'http://logs.logdna.com'

    def initialize(api_key, opts = {})
      params = {
        logdev: opts[:logdev] || STDOUT,
        shift_age: opts[:shift_age] || 7,
        shift_size: opts[:shift_size] || 1_048_576
      }
      super(params[:logdev], params[:shift_age], params[:shift_size])

      @api_key = api_key
      @host = opts[:hostname]
      @mac = opts[:mac]
      @ip = opts[:ip]
    end

    def <<(msg)
      super(msg)
      post_to_logdna(msg)
    end

    def add(severity, message = nil, progname = nil)
      super
      post_to_logdna(message, severity, progname)
    end

    private

    def post_to_logdna(message, level = nil, app = nil)
      @conn.post do |req|
        req.url 'logs/ingest', hostname: @host, mac: @mac, ip: @ip, now: Time.now
        req[:apikey] = @api_key
        req['content-type'] = 'application/json'
        req.body = request_body(message, level, app)
      end
    end

    def request_body(message, level, app)
      body = { message: message, timestamp: Time.now }
      body[:level] = level if level
      body[:app] = app if app
      JSON.generate(body)
    end
  end
end
