# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_signatures/version'

Gem::Specification.new do |spec|
  spec.name          = 'http_signatures'
  spec.version       = HttpSignatures::VERSION
  spec.authors       = ['Paul Annesley']
  spec.email         = ['paul@annesley.cc']
  spec.summary       = 'Sign and verify HTTP messages'
  spec.homepage      = 'https://github.com/99designs/http-signatures-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler', '~> 2.0')
  spec.add_development_dependency('pry', '~> 0.12')
  spec.add_development_dependency('rake', '~> 12.3')
  spec.add_development_dependency('rubocop-performance', '~> 1.4')
  spec.add_development_dependency('rubocop-rspec', '~> 1.34')
end
