# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scruby/version"

Gem::Specification.new do |s|
  s.name        = "scruby"
  s.version     = Scruby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Macario Ortega"]
  s.email       = ["macarui@gmail.com"]
  s.homepage    = "http://github.com/maca/scruby"
  s.summary     = %q{SuperCollider client for Ruby}
  s.description = %q{SuperCollider client for Ruby}

  s.rubyforge_project = "scruby"

  s.add_development_dependency 'rspec'
  s.add_dependency 'ruby-osc', '~> 0.3'
  s.add_dependency 'arguments', '~> 0.6'
  s.add_dependency 'live', '~> 0.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
