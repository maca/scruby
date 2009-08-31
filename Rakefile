require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/scruby'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'scruby' do
  self.developer 'Macario Ortega', 'macarui@gmail.com'
  self.summary            = %q{SuperCollider client for Ruby}
  self.rubyforge_name     = self.name
  self.extra_deps         = [
    ['maca-arguments',  '>= 0.6'],
    ['maca-ruby-osc',   '>= 0.3.1']
  ]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
task :default => [:spec]
