require 'json'
require_relative './logdna/version'

module LogDNA
  INGESTER_DOMAIN = 'https://logs.logdna.com'.freeze

  LEVELS = {
    0 => 'DEBUG',
    1 => 'INFO',
    2 => 'WARN',
    3 => 'ERROR',
    4 => 'FATAL',
    5 => 'UNKNOWN'
  }.freeze

  def add(severity, message = nil, progname = nil)
    super
    message ||= yield
    post_to_logdna(message, severity, progname)
  end

  private

  def fill_opts_with_defaults(opts)
    # defaults from ruby standard library logger documentation
    opts[:logdev] ||= STDOUT
    opts[:shift_age] ||= 7
    opts[:shift_size] ||= 1_048_576
    opts
  end

  def set_ivars(api_key, hostname, opts)
    @api_key = api_key
    @host = hostname
    @mac = opts[:mac]
    @ip = opts[:ip]
    @logdev = opts[:logdev]
  end

  def post_to_logdna(message, level = nil, source = 'none')
    res = @conn.headers(apikey: @api_key, 'Content-Type' => 'application/json')
               .post("/logs/ingest?hostname=#{@host}&mac=#{@mac}&ip=#{@ip}",
                     json: request_body(message, level, source))

    puts JSON.generate(request_body(message, level, source))
    puts res.to_s
  end

  def request_body(message, level, source)
    body = { e: 'line', line: message, timestamp: Time.now }
    body[:level] = LEVELS[level] if level
    body[:app] = source if source
    body
  end
end
