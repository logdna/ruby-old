# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logdna/version'

Gem::Specification.new do |spec|
  spec.name          = 'logdna'
  spec.version       = LogDNA::VERSION
  spec.authors       = ['edwin-lai']
  spec.email         = ['edwinlai@ucla.edu']

  spec.summary       = 'LogDNA extension to ruby logger'
  spec.homepage      = 'https://github.com/logdna/logdna_ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'http', '~> 2.0', '>= 2.0.3'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
end
