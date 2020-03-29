lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scruby/version"

Gem::Specification.new do |spec|
  spec.name          = "scruby"
  spec.version       = Scruby::VERSION
  spec.authors       = [ "Macario" ]
  spec.email         = [ "maca@aelita.io" ]
  spec.summary       = "SuperCollider client for Ruby"
  spec.description   = "SuperCollider client for Ruby"
  spec.homepage      = "http://github.com/maca/scruby"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is
  # released.  The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "irb"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "zeitwerk"
  spec.add_development_dependency "listen"
  spec.add_development_dependency "rubocop"

  spec.add_dependency "live", "~> 0.1"
  spec.add_dependency "ruby-osc", "~> 1.0"
  spec.add_dependency "tty-which", "~> 0.4"
  spec.add_dependency "concurrent-ruby", "~> 1.1"
  spec.add_dependency "concurrent-ruby-edge", "~> 0.5.0"
  spec.add_dependency "facets", "~> 3.1"
end
