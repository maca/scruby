# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scruby}
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2009-08-07}
  s.default_executable = %q{livecode.rb}
  s.description = %q{}
  s.email = ["macarui@gmail.com"]
  s.executables = ["livecode.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "TODO.markdown", "bin/livecode.rb", "examples/example.live.rb", "extras/Ruby Live.tmbundle/Commands/Run selection:line in session.tmCommand", "extras/Ruby Live.tmbundle/Commands/Run selection:scope in session.tmCommand", "extras/Ruby Live.tmbundle/Commands/Run update blocks in session.tmCommand", "extras/Ruby Live.tmbundle/Commands/Start Session.tmCommand", "extras/Ruby Live.tmbundle/Commands/Stop server.tmCommand", "extras/Ruby Live.tmbundle/Support/lib/live_session.rb", "extras/Ruby Live.tmbundle/Syntaxes/Ruby Live.tmLanguage", "extras/Ruby Live.tmbundle/info.plist", "lib/live/session.rb", "lib/scruby.rb", "lib/scruby/buffer.rb", "lib/scruby/bus.rb", "lib/scruby/control_name.rb", "lib/scruby/core_ext/array.rb", "lib/scruby/core_ext/delegator_array.rb", "lib/scruby/core_ext/fixnum.rb", "lib/scruby/core_ext/numeric.rb", "lib/scruby/core_ext/object.rb", "lib/scruby/core_ext/proc.rb", "lib/scruby/core_ext/string.rb", "lib/scruby/core_ext/symbol.rb", "lib/scruby/core_ext/typed_array.rb", "lib/scruby/env.rb", "lib/scruby/group.rb", "lib/scruby/node.rb", "lib/scruby/server.rb", "lib/scruby/synth.rb", "lib/scruby/synthdef.rb", "lib/scruby/ugens/env_gen.rb", "lib/scruby/ugens/in_out.rb", "lib/scruby/ugens/multi_out_ugens.rb", "lib/scruby/ugens/operation_indices.yaml", "lib/scruby/ugens/operation_ugens.rb", "lib/scruby/ugens/ugen.rb", "lib/scruby/ugens/ugen_defs.yaml", "lib/scruby/ugens/ugen_operations.rb", "lib/scruby/ugens/ugens.rb", "notas.markdown", "script/console", "script/destroy", "script/generate", "scruby.gemspec", "spec/buffer_spec.rb", "spec/bus_spec.rb", "spec/core_ext/core_ext_spec.rb", "spec/core_ext/delegator_array_spec.rb", "spec/core_ext/typed_array_spec.rb", "spec/env_gen_spec.rb", "spec/env_spec.rb", "spec/group_spec.rb", "spec/helper.rb", "spec/in_out_spec.rb", "spec/integration_spec.rb", "spec/multiout_ugen_spec.rb", "spec/node_spec.rb", "spec/operation_ugens_spec.rb", "spec/server.rb", "spec/server_spec.rb", "spec/synth_spec.rb", "spec/synthdef_spec.rb", "spec/ugen_operations_spec.rb", "spec/ugen_spec.rb", "spec/ugens_spec.rb", "test.live.rb"]
  s.has_rdoc = true
  s.homepage = %q{Is a bare-bones SuperCollider livecoding library for Ruby, it provides comunication with a remote or local scsynth server and SynthDef creation with a}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{scruby}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<maca-arguments>, [">= 0.6"])
      s.add_runtime_dependency(%q<maca-rosc>, [">= 0.4.2"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<maca-arguments>, [">= 0.6"])
      s.add_dependency(%q<maca-rosc>, [">= 0.4.2"])
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<maca-arguments>, [">= 0.6"])
    s.add_dependency(%q<maca-rosc>, [">= 0.4.2"])
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
