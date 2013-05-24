# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex-webmaster/version'

Gem::Specification.new do |spec|
  spec.name          = "yandex-webmaster"
  spec.version       = Yandex::Webmaster::Version::STRING
  spec.authors       = ["Igor Alexandrov"]
  spec.email         = ["igor.alexandrov@gmail.com"]  
  spec.summary       = "Ruby wrapper for Yandex.Webmaster API"
  spec.homepage      = "http://github.com/igor-alexandrov/yandex-webmaster"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'oauth2'
  spec.add_dependency 'libxml-ruby'
  spec.add_dependency 'attrio'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock', '~> 1.9.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end