# RSpec.describe SynthDef, "instantiation" do
#   include Scruby
#   include Ugens

#   describe "initialize" do
#     let(:synth_def) { SynthDef.new(:name){} }

#     before do
#       allow(synth_def).to receive :collect_control_names
#     end

#     it "should accept name and set it as an attribute as string" do
#       expect(synth_def.name).to eq("name")
#     end

#     it "should initialize with an empty array for children" do
#       expect(synth_def.children).to eq([])
#     end
#   end

#   # describe "#collect_control_names" do
#   #   before do
#   #     synth_def     = SynthDef.new(:name){}
#   #     @function = double "grap_function", arguments: %i(arg1 arg2 arg3)
#   #   end

#   #   it "should get the argument names for the provided function" do
#   #     expect(@function).to receive(:arguments).and_return []
#   #     synth_def.send_msg :collect_control_names, @function, [], []
#   #   end

#   #   it "should return empty array if the names are empty" do
#   #     expect(@function).to receive(:arguments).and_return []
#   #     expect(synth_def.send_msg(:collect_control_names, @function, [], [])).to eq([])
#   #   end

#   #   it "should not return empty array if the names are not empty" do
#   #     expect(synth_def.send_msg(:collect_control_names, @function, [], [])).not_to eq([])
#   #   end

#   #   it "should instantiate and return a ControlName for each function name" do
#   #     c_name = double :control_name
#   #     expect(ControlName).to receive(:new).at_most(3).times.and_return c_name
#   #     control_names = synth_def.send_msg :collect_control_names, @function, [ 1, 2, 3 ], []
#   #     expect(control_names.size).to eq(3)
#   #     control_names.map { |e| expect(e).to eq(c_name) }
#   #   end

#   #   it "should pass the argument value, the argument index and the rate(if provided) to the ControlName at instantiation" do
#   #     cns = synth_def.send_msg :collect_control_names, @function, [ 1, 2, 3 ], []
#   #     expect(cns).to eq([ 1.0, 2.0, 3.0 ].map{ |val| ControlName.new("arg#{ val.to_i }", val, :control, val.to_i - 1) })
#   #     cns = synth_def.send_msg :collect_control_names, @function, [ 1, 2, 3 ], %i(ir tr ir)
#   #     expect(cns).to eq([[ 1.0, :ir ], [ 2.0, :tr ], [ 3.0, :ir ]].map{ |val, rate| ControlName.new("arg#{ val.to_i }", val, rate, val.to_i - 1) })
#   #   end

#   #   it "should not return more elements than the function argument number" do
#   #     expect(synth_def.send_msg(:collect_control_names, @function, [ 1, 2, 3, 4, 5 ], []).size).to eq(3)
#   #   end
#   # end

#   # describe "#build_controls" do
#   #   before :all do
#   #     RATES = %i(scalar trigger control).freeze
#   #   end

#   #   before do
#   #     synth_def     = SynthDef.new(:name){}
#   #     @function = double "grap_function", arguments: %i(arg1 arg2 arg3 arg4)
#   #     @control_names = Array.new(rand(15..24)) { |i| ControlName.new "arg#{i + 1}".to_sym, i, RATES[rand(3)], i }
#   #   end

#   #   it "should call Control#and_proxies.." do
#   #     rates = @control_names.map(&:rate).uniq
#   #     expect(Control).to receive(:and_proxies_from).exactly(rates.size).times
#   #     synth_def.send_msg :build_controls, @control_names
#   #   end

#   #   it "should call Control#and_proxies.. with args" do
#   #     expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :scalar  }) unless @control_names.select{ |c| c.rate == :scalar  }.empty?
#   #     expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :trigger }) unless @control_names.select{ |c| c.rate == :trigger }.empty?
#   #     expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :control }) unless @control_names.select{ |c| c.rate == :control }.empty?
#   #     synth_def.send_msg(:build_controls, @control_names)
#   #   end

#   #   it do
#   #     expect(synth_def.send_msg(:build_controls, @control_names)).to be_instance_of(Array)
#   #   end

#   #   it "should return an array of OutputProxies" do
#   #     synth_def.send_msg(:build_controls, @control_names).each { |e| expect(e).to be_instance_of(OutputProxy) }
#   #   end

#   #   it "should return an array of OutputProxies sorted by ControlNameIndex" do
#   #     expect(synth_def.send_msg(:build_controls, @control_names).map{ |p| p.control_name.index }).to eq((0...@control_names.size).to_a)
#   #   end

#   #   it "should call graph function with correct args" do
#   #     function = double("function", call: [])
#   #     proxies  = synth_def.send_msg(:build_controls, @control_names)
#   #     allow(synth_def).to receive(:build_controls).and_return(proxies)
#   #     expect(function).to receive(:call).with(*proxies)
#   #     synth_def.send_msg(:build_ugen_graph, function, @control_names)
#   #   end

#   #   it "should set synth_def" do
#   #     function = lambda{}
#   #     expect(Ugen).to receive(:synthdef=).with(synth_def)
#   #     expect(Ugen).to receive(:synthdef=).with(nil)
#   #     synth_def.send_msg(:build_ugen_graph, function, [])
#   #   end

#   #   it "should collect constants for simple children array" do
#   #     children = [ MockUgen.new(:audio, 100), MockUgen.new(:audio, 200), MockUgen.new(:audio, 100, 300) ]
#   #     expect(synth_def.send_msg(:collect_constants, children)).to eq([ 100.0, 200.0, 300.0 ])
#   #   end

#   #   it "should collect constants for children arrays" do
#   #     children = [ MockUgen.new(:audio, 100), [ MockUgen.new(:audio, 400), [ MockUgen.new(:audio, 200), MockUgen.new(:audio, 100, 300) ]]]
#   #     expect(synth_def.send_msg(:collect_constants, children)).to eq([ 100.0, 400.0, 200.0, 300.0 ])
#   #   end

#   #   it "should remove nil from constants array"
#   # end
# end
