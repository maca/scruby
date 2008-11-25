require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'


spec = Gem::Specification.new do |s| 
  s.name = "Scruby"
  s.version = "0.0.7"
  s.author = "Macario Ortega"
  s.email = "macarui@gmail.com"
  s.homepage = "http://github.org/maca/scruby"
  s.platform = Gem::Platform::RUBY
  s.summary = "Small client for doing sound synthesis from ruby using the SuperCollider synth, usage is quite similar from SuperCollider."
  s.files = Dir["./*"] + Dir["*/**"] + Dir["*/**/**"] + Dir["*/**/**/**"]
  s.require_path = "lib"
  s.bindir = 'bin'
  s.autorequire = "scruby"
  s.test_files = Dir['spec/*'] + Dir['spec/**/*']
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.add_dependency "highline", ">= 1.4.0"
  s.add_dependency "ruby2ruby", ">= 1.1.9"
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = false
end 
