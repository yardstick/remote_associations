# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remote_associations/version'

Gem::Specification.new do |spec|
  spec.name          = "remote_associations"
  spec.version       = RemoteAssociations::VERSION
  spec.authors       = ["Jason Wall"]
  spec.email         = ["jasonw@getyardstick.com"]
  spec.description   = %q{Gem for preloading remote data to a relation of active record instances}
  spec.summary       = %q{Similar to how you can preload children or parents records for your ActiveRecord::Relations,
    use remote associations to tell ActiveRecord how to get all the remote entities associated with a given relation
    in one HTTP request}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", '>= 3.2.16'

  spec.add_development_dependency "activerecord", '>= 3.2.16' # currently for active_model in the specs
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14.0"
  spec.add_development_dependency "mocha", '~> 0.14.0'
  spec.add_development_dependency "pry", '~> 0.9'
  spec.add_development_dependency "pry-debugger", '~> 0.2'
end
