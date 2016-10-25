require 'json'
require 'logdna_ruby/version'

module LogDNA
  @log_domain = 'http://logs.logdna.com'

  def add(severity, message = nil, progname = nil)
    super
    post_to_logdna(message, severity, progname)
  end

  private

  def fill_opts_with_defaults(opts)
    # defaults from ruby standard library logger documentation
    opts[:logdev] ||= STDOUT
    opts[:shift_age] ||= 7
    opts[:shift_size] || 1_048_576
    opts
  end

  def set_ivars(api_key, hostname, opts)
    @api_key = api_key
    @host = hostname
    @mac = opts[:mac]
    @ip = opts[:ip]
  end

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
