
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redis_record/version"

Gem::Specification.new do |spec|
  spec.name          = "redis_record"
  spec.version       = RedisRecord::VERSION
  spec.authors       = ["Shuhei TAKASUGI"]
  spec.email         = ["shuhei.takasugi@gmail.com"]

  spec.summary       = %q{ operate Redis like ActiveRecord interface }
  spec.description   = %q{ operate Redis like ActiveRecord interface }
  spec.homepage      = "https://github.com/shuyuhey/redis-record"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "redis", "~> 4.0.0"
  spec.add_development_dependency "activemodel", "~> 4.0.0"
end
