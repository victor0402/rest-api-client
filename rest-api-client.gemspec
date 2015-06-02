# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest/api/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'rest-api-client'
  spec.version       = RestApiClient::VERSION
  spec.authors       = ['Victor']
  spec.email         = ['vcarvalho0402@gmail.com']

  spec.summary       = 'rest-api-client'
  spec.description   = 'Common classes and methods to handle rest communication'
  spec.homepage      = 'https://github.com/victor0402/rest-api-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '>= 1.8.0'
  spec.add_runtime_dependency 'redis', '>= 3.2.1'
  spec.add_runtime_dependency 'virtus'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.2.0'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
end
