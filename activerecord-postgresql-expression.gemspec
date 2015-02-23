# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/postgresql/expression/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-postgresql-expression"
  spec.version       = ActiveRecord::PostgreSQL::Expression::VERSION
  spec.authors       = ["Naoya Murakami"]
  spec.email         = ["naoya@createfield.com"]
  spec.summary       = %q{Adds expression to migrations for ActiveRecord PostgreSQL adapters}
  spec.description   = %q{Adds expression to migrations for ActiveRecord PostgreSQL adapters}
  spec.homepage      = "https://github.com/naoa/activerecord-postgresql-expression"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "activesupport", "~> 4.0"
  spec.add_runtime_dependency "activerecord", "~> 4.0"
  spec.add_runtime_dependency "pg"
end
