require 'json'
require_relative './logdna/version.rb'
require_relative './logdna/ruby_logger.rb'

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
    return true if severity < @level
    message ||= yield
    push_to_buffer(message, severity, progname) if @open
  end

  def close_http
    return false unless @open
    @conn.close
    @timer.exit if @timer
    @open = false
    true
  end

  def reopen_http
    return false if @open
    @conn = HTTP.persistent LogDNA::INGESTER_DOMAIN
    @open = true
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
    raise ArgumentError 'api_key must be a string' unless api_key.is_a?(String)
    @api_key = api_key
    @host = hostname.to_s
    @mac = opts[:mac].to_s
    @ip = opts[:ip].to_s
    @buffer = []
    @buffer_max = opts[:buffer_max_size] || 10
    @freq = opts[:buffer_timeout] || 10
    @open = true
  end

  def post
    res = @conn.headers(apikey: @api_key, 'Content-Type' => 'application/json')
               .post("/logs/ingest?hostname=#{@host}&mac=#{@mac}&ip=#{@ip}",
                     json: { e: 'ls', ls: @buffer })
    @buffer = []
    res.flush
  end

  def push_to_buffer(message, level = nil, source = 'none')
    line = { line: message, app: source, timestamp: Time.now.to_i }
    line[:level] = LEVELS[level] if level
    start_timer if @buffer.empty?
    @buffer << line
    return if @buffer.size < @buffer_max
    @timer.exit
    post
  end

  def start_timer
    @timer = Thread.new do
      sleep @freq
      unless @buffer.empty?
        res = @conn.headers(apikey: @api_key, 'Content-Type' => 'application/json')
                   .post("/logs/ingest?hostname=#{@host}&mac=#{@mac}&ip=#{@ip}",
                         json: { e: 'ls', ls: @buffer })
        @buffer = []
        res.flush
      end
    end
  end
end
