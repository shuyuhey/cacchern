# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cacchern/version'

Gem::Specification.new do |spec|
  spec.name          = 'cacchern'
  spec.version       = Cacchern::VERSION
  spec.authors       = ['Shuhei TAKASUGI']
  spec.email         = ['shuhei.takasugi@gmail.com']

  spec.summary       = ' operate Redis like ActiveRecord interface '
  spec.description   = ' operate Redis like ActiveRecord interface '
  spec.homepage      = 'https://github.com/shuyuhey/cacchern'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 5.2.2', '< 6.0.0'
  spec.add_dependency 'activesupport', '>= 5.2.2', '< 6.0.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'redis', '>= 4.0.0', '< 4.2.0'
end
