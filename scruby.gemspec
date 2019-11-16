lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scruby/version"

Gem::Specification.new do |spec|
  spec.name          = "scruby"
  spec.version       = Scruby::VERSION
  spec.authors       = ["Macario"]
  spec.email         = ["maca@aelita.io"]
  spec.summary       = "SuperCollider client for Ruby"
  spec.description   = "SuperCollider client for Ruby"
  spec.homepage      = "http://github.com/maca/scruby"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is
  # released.  The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "irb"
  spec.add_dependency "ruby-osc", "~> 0.3"
  spec.add_dependency "live", "~> 0.1"
end
