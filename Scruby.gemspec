# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Scruby}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2009-02-05}
  s.default_executable = %q{live_session.rb}
  s.description = %q{Small client for doing sound synthesis from ruby using the SuperCollider synth, usage is quite similar from SuperCollider.}
  s.email = %q{macarui@gmail.com}
  s.executables = ["live_session.rb"]
  s.extra_rdoc_files = ["bin/live_session.rb", "lib/live/session.rb", "lib/scruby/audio/control_name.rb", "lib/scruby/audio/env.rb", "lib/scruby/audio/node.rb", "lib/scruby/audio/server.rb", "lib/scruby/audio/synth.rb", "lib/scruby/audio/synthdef.rb", "lib/scruby/audio/ugens/env_gen.rb", "lib/scruby/audio/ugens/in_out.rb", "lib/scruby/audio/ugens/multi_out_ugens.rb", "lib/scruby/audio/ugens/operation_indices.yaml", "lib/scruby/audio/ugens/operation_ugens.rb", "lib/scruby/audio/ugens/ugen.rb", "lib/scruby/audio/ugens/ugen_defs.yaml", "lib/scruby/audio/ugens/ugen_operations.rb", "lib/scruby/audio/ugens/ugens.rb", "lib/scruby/control/metro.rb", "lib/scruby/extensions.rb", "lib/scruby/typed_array.rb", "lib/scruby.rb", "README.rdoc"]
  s.files = ["bin/live_session.rb", "changes", "lib/live/session.rb", "lib/scruby/audio/control_name.rb", "lib/scruby/audio/env.rb", "lib/scruby/audio/node.rb", "lib/scruby/audio/server.rb", "lib/scruby/audio/synth.rb", "lib/scruby/audio/synthdef.rb", "lib/scruby/audio/ugens/env_gen.rb", "lib/scruby/audio/ugens/in_out.rb", "lib/scruby/audio/ugens/multi_out_ugens.rb", "lib/scruby/audio/ugens/operation_indices.yaml", "lib/scruby/audio/ugens/operation_ugens.rb", "lib/scruby/audio/ugens/ugen.rb", "lib/scruby/audio/ugens/ugen_defs.yaml", "lib/scruby/audio/ugens/ugen_operations.rb", "lib/scruby/audio/ugens/ugens.rb", "lib/scruby/control/metro.rb", "lib/scruby/extensions.rb", "lib/scruby/typed_array.rb", "lib/scruby.rb", "Rakefile", "README.rdoc", "spec/audio/env_gen_specs.rb", "spec/audio/in_out_spec.rb", "spec/audio/integration_spec.rb", "spec/audio/lib_spec.rb", "spec/audio/multiout_ugen_spec.rb", "spec/audio/node_spec.rb", "spec/audio/operation_ugens_spec.rb", "spec/audio/server_spec.rb", "spec/audio/synth_spec.rb", "spec/audio/synthdef_spec.rb", "spec/audio/ugen_operations_spec.rb", "spec/audio/ugen_spec.rb", "spec/audio/ugens_spec.rb", "spec/env_spec.rb", "spec/extensions_spec.rb", "spec/helper.rb", "spec/typed_array_spec.rb", "Manifest", "Scruby.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/maca/scruby}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Scruby", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{scruby}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Small client for doing sound synthesis from ruby using the SuperCollider synth, usage is quite similar from SuperCollider.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
