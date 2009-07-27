require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen"
require "scruby/ugens/ugen_operations"
require "scruby/synthdef" 
require "scruby/ugens/multi_out_ugens"
require "scruby/core_ext/typed_array"

include Scruby
include Ugens


describe SynthDef, 'instantiation' do
  
  describe 'initialize' do
    before do
    @sdef = SynthDef.new( :name ){}
    @sdef.stub! :collect_control_names
  end

    it "should instantiate" do
    @sdef.should_not be_nil
    @sdef.should be_instance_of( SynthDef )
  end
  
    it "should protect attributes" do
    @sdef.should_not respond_to( :name= )
    @sdef.should_not respond_to( :children= )
    @sdef.should_not respond_to( :constants= )
    @sdef.should_not respond_to( :control_names= )

    @sdef.should respond_to( :name )
    @sdef.should respond_to( :children )
    @sdef.should respond_to( :constants )
    @sdef.should respond_to( :control_names )
  end
  
    it "should accept name and set it as an attribute as string" do
    @sdef.name.should == 'name'
  end

    it "should initialize with an empty array for children" do
    @sdef.children.should == []
  end
  end
  
  describe "options" do
    before do
      @options = mock Hash
    end
  
    it "should accept options" do
      sdef = SynthDef.new( :hola, :values => [] ){}
    end
    
    it "should use options" do
      @options.should_receive(:delete).with :values
      @options.should_receive(:delete).with :rates
      
      sdef = SynthDef.new( :hola, @options ){}
    end
    
    it "should set default values if not provided" 
    it "should accept a graph function"
    
  end
  
  describe '#collect_control_names' do
    before do
      @sdef     = SynthDef.new( :name ){}
      @function = mock "grap_function", :arguments => [:arg1, :arg2, :arg3]
    end
    
    it "should get the argument names for the provided function" do
      @function.should_receive( :arguments ).and_return []
      @sdef.send_msg :collect_control_names, @function, [], []
    end
    
    it "should return empty array if the names are empty" do
      @function.should_receive( :arguments ).and_return []
      @sdef.send_msg( :collect_control_names, @function, [], [] ).should == []
    end
    
    it "should not return empty array if the names are not empty" do
      @sdef.send_msg( :collect_control_names, @function, [], [] ).should_not == []
    end
    
    it "should instantiate and return a ControlName for each function name" do
      c_name = mock :control_name
      ControlName.should_receive( :new ).at_most(3).times.and_return c_name
      control_names = @sdef.send_msg :collect_control_names, @function, [1,2,3], []
      control_names.size.should == 3
      control_names.collect { |e| e.should == c_name }
    end
    
    it "should pass the argument value, the argument index and the rate(if provided) to the ControlName at instantiation" do
      cns = @sdef.send_msg :collect_control_names, @function, [1, 2, 3], []
      cns.should == [1.0, 2.0, 3.0].map{ |val| ControlName.new("arg#{ val.to_i }", val, :control, val.to_i - 1 )}
      cns = @sdef.send_msg :collect_control_names, @function, [1, 2, 3], [:ir, :tr, :ir]
      cns.should == [[1.0, :ir], [2.0, :tr], [3.0, :ir]].map{ |val, rate| ControlName.new("arg#{ val.to_i }", val, rate, val.to_i - 1 )}
    end
    
    it "should not return more elements than the function argument number" do
      @sdef.send_msg( :collect_control_names, @function, [1, 2, 3, 4, 5], [] ).should have( 3 ).elements
    end
  end

  describe '#build_controls' do
    before :all do
      RATES = [:scalar, :trigger, :control]
    end
    
    before do
      @sdef     = SynthDef.new( :name ){}
      @function = mock "grap_function", :arguments => [:arg1, :arg2, :arg3, :arg4]
      @control_names = Array.new( rand(10)+15 ) { |i| ControlName.new "arg#{i+1}".to_sym, i, RATES[ rand(3) ], i }
    end

    it "should call Control#and_proxies.." do
        rates = @control_names.collect{ |c| c.rate }.uniq
        Control.should_receive(:and_proxies_from).exactly( rates.size ).times
        @sdef.send_msg :build_controls, @control_names
    end
    
    it "should call Control#and_proxies.. with args" do
      Control.should_receive(:and_proxies_from).with( @control_names.select{ |c| c.rate == :scalar  } ) unless @control_names.select{ |c| c.rate == :scalar  }.empty?
      Control.should_receive(:and_proxies_from).with( @control_names.select{ |c| c.rate == :trigger } ) unless @control_names.select{ |c| c.rate == :trigger }.empty?
      Control.should_receive(:and_proxies_from).with( @control_names.select{ |c| c.rate == :control } ) unless @control_names.select{ |c| c.rate == :control }.empty?
      @sdef.send_msg( :build_controls, @control_names )
    end
    
    it do
      @sdef.send_msg( :build_controls, @control_names ).should be_instance_of(Array)
    end

    it "should return an array of OutputProxies" do
      @sdef.send_msg( :build_controls, @control_names ).each { |e| e.should be_instance_of(OutputProxy) }
    end
    
    it "should return an array of OutputProxies sorted by ControlNameIndex" do
      @sdef.send_msg( :build_controls, @control_names ).collect{ |p| p.control_name.index }.should == (0...@control_names.size).to_a
    end
    
    it "should call graph function with correct args" do
      function = mock("function", :call => [] )
      proxies  = @sdef.send_msg( :build_controls, @control_names )
      @sdef.stub!( :build_controls ).and_return( proxies )
      function.should_receive( :call ).with( *proxies )
      @sdef.send_msg( :build_ugen_graph, function, @control_names)
    end
    
    it "should set @sdef" do
      function = lambda{}
      Ugen.should_receive( :synthdef= ).with( @sdef )
      Ugen.should_receive( :synthdef= ).with( nil )      
      @sdef.send_msg( :build_ugen_graph, function, [] )
    end
    
    it "should collect constants for simple children array" do
      children = [Ugen.new(:audio, 100), Ugen.new(:audio, 200), Ugen.new(:audio, 100, 300)]
      @sdef.send_msg( :collect_constants, children).should == [100.0, 200.0, 300.0]
    end
    
    it "should collect constants for children arrays" do
      children = [ Ugen.new(:audio, 100), [ Ugen.new(:audio, 400), [ Ugen.new(:audio, 200), Ugen.new(:audio, 100, 300) ] ] ]
      @sdef.send_msg( :collect_constants, children).should == [100.0, 400.0, 200.0, 300.0]
    end
    
    it "should remove nil from constants array"
    
  end
  
end


describe "encoding" do

  before :all do
    class Spec::SinOsc < Ugen
      def self.ar freq = 440.0, phase = 0.0 #not interested in muladd
        new :audio, freq, phase
      end
    end
  end
  
  before do
    @sdef = SynthDef.new(:hola) { Spec::SinOsc.ar }
    @encoded = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 0, 0 ].pack('C*')
  end
  
  it "should get values" do
    @sdef.values
  end
  
  it "should encode init stream" do
    @sdef.encode[0..9].should == @encoded[0..9]
  end
  
  it "should encode is, name" do
    @sdef.encode[0..14].should == @encoded[0..14]
  end
  
  it "should encode is, name, constants" do
    @sdef.encode[0..24].should == @encoded[0..24]
  end
  
  it "should encode is, name, consts, values" do
    @sdef.encode[0..26].should == @encoded[0..26]
  end

  it "should encode is, name, consts, values, controls" do
    @sdef.encode[0..28].should == @encoded[0..28]
  end
  
  it "should encode is, name, consts, values, controls, children" do
    @sdef.encode[0..53].should == @encoded[0..53]
  end
  
  it "should encode is, name, consts, values, controls, children, variants stub" do
    @sdef.encode.should == @encoded
  end
  
  describe "sending" do

    before :all do
      @server  = mock('server', :instance_of? => true, :send_synth_def => nil)
      ::Server = mock('Server', :all => [@server])
    end
    
    before do
      @servers = (0..3).map{ mock('server', :instance_of? => true, :send_synth_def => nil) }
      @sdef = SynthDef.new(:hola) { Spec::SinOsc.ar }
    end
    
    it "should accept an array or several Servers" do
      @sdef.send @servers
      @sdef.send *@servers
    end
    
    it "should not accept non servers" do
      lambda{ @sdef.send [1, 2] }.should raise_error(NoMethodError)
      lambda{ @sdef.send 1, 2 }.should   raise_error(NoMethodError)
    end
    
    it "should send self to each of the servers" do
      @servers.each{ |s| s.should_receive(:send_synth_def).with(@sdef) }
      @sdef.send( @servers )
    end
    
    it "should send to Server.all if not provided with a list of servers" do
      @server.should_receive(:send_synth_def).with(@sdef)
      Server.should_receive(:all).and_return([@server])
      @sdef.send
    end
  end  
end




