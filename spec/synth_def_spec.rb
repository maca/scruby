# frozen_string_literal: true

include Scruby
include Ugens

class MockUgen < Ugen
  class << self; public :new; end
end


RSpec.describe SynthDef, "instantiation" do

  describe "initialize" do
    before do
      @sdef = SynthDef.new(:name){}
      allow(@sdef).to receive :collect_control_names
    end

    it "should instantiate" do
      expect(@sdef).not_to be_nil
      expect(@sdef).to be_instance_of(SynthDef)
    end

    it "should protect attributes" do
      expect(@sdef).not_to respond_to(:name=)
      expect(@sdef).not_to respond_to(:children=)
      expect(@sdef).not_to respond_to(:constants=)
      expect(@sdef).not_to respond_to(:control_names=)

      expect(@sdef).to respond_to(:name)
      expect(@sdef).to respond_to(:children)
      expect(@sdef).to respond_to(:constants)
      expect(@sdef).to respond_to(:control_names)
    end

    it "should accept name and set it as an attribute as string" do
      expect(@sdef.name).to eq("name")
    end

    it "should initialize with an empty array for children" do
      expect(@sdef.children).to eq([])
    end
  end

  describe "options" do
    before do
      @options = double Hash
    end

    it "should accept options" do
      sdef = SynthDef.new(:hola, values: []){}
    end

    it "should use options" do
      expect(@options).to receive(:delete).with :values
      expect(@options).to receive(:delete).with :rates

      sdef = SynthDef.new(:hola, @options){}
    end

    it "should set default values if not provided"
    it "should accept a graph function"

  end

  describe "#collect_control_names" do
    before do
      @sdef     = SynthDef.new(:name){}
      @function = double "grap_function", arguments: %i(arg1 arg2 arg3)
    end

    it "should get the argument names for the provided function" do
      expect(@function).to receive(:arguments).and_return []
      @sdef.send_msg :collect_control_names, @function, [], []
    end

    it "should return empty array if the names are empty" do
      expect(@function).to receive(:arguments).and_return []
      expect(@sdef.send_msg(:collect_control_names, @function, [], [])).to eq([])
    end

    it "should not return empty array if the names are not empty" do
      expect(@sdef.send_msg(:collect_control_names, @function, [], [])).not_to eq([])
    end

    it "should instantiate and return a ControlName for each function name" do
      c_name = double :control_name
      expect(ControlName).to receive(:new).at_most(3).times.and_return c_name
      control_names = @sdef.send_msg :collect_control_names, @function, [ 1, 2, 3 ], []
      expect(control_names.size).to eq(3)
      control_names.map { |e| expect(e).to eq(c_name) }
    end

    it "should pass the argument value, the argument index and the rate(if provided) to the ControlName at instantiation" do
      cns = @sdef.send_msg :collect_control_names, @function, [ 1, 2, 3 ], []
      expect(cns).to eq([ 1.0, 2.0, 3.0 ].map{ |val| ControlName.new("arg#{ val.to_i }", val, :control, val.to_i - 1) })
      cns = @sdef.send_msg :collect_control_names, @function, [ 1, 2, 3 ], %i(ir tr ir)
      expect(cns).to eq([[ 1.0, :ir ], [ 2.0, :tr ], [ 3.0, :ir ]].map{ |val, rate| ControlName.new("arg#{ val.to_i }", val, rate, val.to_i - 1) })
    end

    it "should not return more elements than the function argument number" do
      expect(@sdef.send_msg(:collect_control_names, @function, [ 1, 2, 3, 4, 5 ], []).size).to eq(3)
    end
  end

  describe "#build_controls" do
    before :all do
      RATES = %i(scalar trigger control).freeze
    end

    before do
      @sdef     = SynthDef.new(:name){}
      @function = double "grap_function", arguments: %i(arg1 arg2 arg3 arg4)
      @control_names = Array.new(rand(15..24)) { |i| ControlName.new "arg#{i + 1}".to_sym, i, RATES[rand(3)], i }
    end

    it "should call Control#and_proxies.." do
      rates = @control_names.map(&:rate).uniq
      expect(Control).to receive(:and_proxies_from).exactly(rates.size).times
      @sdef.send_msg :build_controls, @control_names
    end

    it "should call Control#and_proxies.. with args" do
      expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :scalar  }) unless @control_names.select{ |c| c.rate == :scalar  }.empty?
      expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :trigger }) unless @control_names.select{ |c| c.rate == :trigger }.empty?
      expect(Control).to receive(:and_proxies_from).with(@control_names.select{ |c| c.rate == :control }) unless @control_names.select{ |c| c.rate == :control }.empty?
      @sdef.send_msg(:build_controls, @control_names)
    end

    it do
      expect(@sdef.send_msg(:build_controls, @control_names)).to be_instance_of(Array)
    end

    it "should return an array of OutputProxies" do
      @sdef.send_msg(:build_controls, @control_names).each { |e| expect(e).to be_instance_of(OutputProxy) }
    end

    it "should return an array of OutputProxies sorted by ControlNameIndex" do
      expect(@sdef.send_msg(:build_controls, @control_names).map{ |p| p.control_name.index }).to eq((0...@control_names.size).to_a)
    end

    it "should call graph function with correct args" do
      function = double("function", call: [])
      proxies  = @sdef.send_msg(:build_controls, @control_names)
      allow(@sdef).to receive(:build_controls).and_return(proxies)
      expect(function).to receive(:call).with(*proxies)
      @sdef.send_msg(:build_ugen_graph, function, @control_names)
    end

    it "should set @sdef" do
      function = lambda{}
      expect(Ugen).to receive(:synthdef=).with(@sdef)
      expect(Ugen).to receive(:synthdef=).with(nil)
      @sdef.send_msg(:build_ugen_graph, function, [])
    end

    it "should collect constants for simple children array" do
      children = [ MockUgen.new(:audio, 100), MockUgen.new(:audio, 200), MockUgen.new(:audio, 100, 300) ]
      expect(@sdef.send_msg(:collect_constants, children)).to eq([ 100.0, 200.0, 300.0 ])
    end

    it "should collect constants for children arrays" do
      children = [ MockUgen.new(:audio, 100), [ MockUgen.new(:audio, 400), [ MockUgen.new(:audio, 200), MockUgen.new(:audio, 100, 300) ]]]
      expect(@sdef.send_msg(:collect_constants, children)).to eq([ 100.0, 400.0, 200.0, 300.0 ])
    end

    it "should remove nil from constants array"

  end

end


RSpec.describe "encoding" do

  before :all do
    class Spec::SinOsc < Ugen
      def self.ar(freq = 440.0, phase = 0.0) # not interested in muladd
        new :audio, freq, phase
      end
    end
  end

  before do
    @sdef = SynthDef.new(:hola) { Spec::SinOsc.ar }
    @encoded = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 0, 0 ].pack("C*")
  end

  it "should get values" do
    @sdef.values
  end

  it "should encode init stream" do
    expect(@sdef.encode[0..9]).to eq(@encoded[0..9])
  end

  it "should encode is, name" do
    expect(@sdef.encode[0..14]).to eq(@encoded[0..14])
  end

  it "should encode is, name, constants" do
    expect(@sdef.encode[0..24]).to eq(@encoded[0..24])
  end

  it "should encode is, name, consts, values" do
    expect(@sdef.encode[0..26]).to eq(@encoded[0..26])
  end

  it "should encode is, name, consts, values, controls" do
    expect(@sdef.encode[0..28]).to eq(@encoded[0..28])
  end

  it "should encode is, name, consts, values, controls, children" do
    expect(@sdef.encode[0..53]).to eq(@encoded[0..53])
  end

  it "should encode is, name, consts, values, controls, children, variants stub" do
    expect(@sdef.encode).to eq(@encoded)
  end

  describe "sending" do

    before :all do
      @server  = double("server", instance_of?: true, send_synth_def: nil)
      ::Server = double("Server", all: [ @server ])
    end

    before do
      @servers = (0..3).map{ double("server", instance_of?: true, send_synth_def: nil) }
      @sdef = SynthDef.new(:hola) { Spec::SinOsc.ar }
    end

    it "should accept an array or several Servers" do
      @sdef.send @servers
      @sdef.send *@servers
    end

    it "should not accept non servers" do
      expect{ @sdef.send [ 1, 2 ] }.to raise_error(NoMethodError)
      expect{ @sdef.send 1, 2 }.to raise_error(NoMethodError)
    end

    it "should send self to each of the servers" do
      @servers.each{ |s| expect(s).to receive(:send_synth_def).with(@sdef) }
      @sdef.send(@servers)
    end

    it "should send to Server.all if not provided with a list of servers" do
      expect(@server).to receive(:send_synth_def).with(@sdef)
      expect(Server).to receive(:all).and_return([ @server ])
      @sdef.send
    end
  end
end
