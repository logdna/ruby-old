require 'spec_helper'
require 'webmock'

describe LogDNA::RubyLogger do
  valid_api_key = 'x' * 32

  before(:example) do
    WebMock.stub_request(:post, 'https://logs.logdna.com/logs/ingest?hostname=test_host&ip=&mac=')
    @logger = LogDNA::RubyLogger.new(valid_api_key,
                                     'test_host',
                                     logdev: StringIO.new,
                                     default_app: 'default_app')
  end

  it 'posts data to the API endpoint' do
    9.times { @logger.add(5, nil, 'test_app') { 'test_message' } }
    # 10th line triggers post from buffer
    res = @logger.add(5, nil, 'test_app') { 'test_message' }
    expect(res.code).to be 200
  end

  it 'buffers output' do
    res = @logger.add(5, nil, 'test_app') { 'test_message' }
    expect(res).to be nil
  end

  it 'does not post data when the severity level is lower than the threshold' do
    @logger.level = 3
    res = @logger.add(0, nil, 'test_app') { 'test_message' }
    expect(res).to be true
  end

  it 'can close the http connection' do
    @logger.close_http
    res = @logger.add(5, nil, 'test_app') { 'test_message' }
    expect(res).to be nil
  end

  it 'does not try to close a closed http connection' do
    @logger.close_http
    expect(@logger.close_http).to be false
  end

  it 'posts data to the API endpoint after the http connection is reopened' do
    @logger.close_http
    @logger.reopen_http
    9.times { @logger.add(5, nil, 'test_app') { 'test_message' } }
    res = @logger.add(5, nil, 'test_app') { 'test_message' }
    expect(res.code).to be 200
  end

  it 'does not try to reopen an open http connection' do
    expect(@logger.reopen_http).to be false
  end

  it 'supports raw message dumps' do
    9.times { @logger << 'test_message' }
    res = @logger << 'test_message'
    expect(res.code).to be 200
  end

  it 'supports setting of default app' do
    expect(@logger.default_app).to eq 'default_app'
  end

  it 'supports environment alias for default_app' do
    expect(@logger.environment).to eq @logger.default_app
  end

  it 'supports setting and getting of log attributes after instantiation' do
    @logger.api_key = 'new_api_key'
    expect(@logger.api_key).to eq 'new_api_key'
    @logger.host = 'new_host'
    expect(@logger.host).to eq 'new_host'
    @logger.default_app = 'new_app'
    expect(@logger.default_app).to eq 'new_app'
    @logger.environment = 'environment'
    expect(@logger.environment).to eq 'environment'
    @logger.ip = '1.2.3.4'
    expect(@logger.ip).to eq '1.2.3.4'
    @logger.mac = 'C0:FF:EE:C0:FF:EE'
    expect(@logger.mac). to eq 'C0:FF:EE:C0:FF:EE'
  end
end
