require File.expand_path(File.dirname(__FILE__)) + "/helper"
require 'yaml'

require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen"
require "scruby/ugens/ugen_operations"
require "scruby/ugens/operation_ugens"
require "scruby/core_ext/object"
require "scruby/core_ext/numeric"
require "scruby/core_ext/string"
require "scruby/core_ext/fixnum"
require "scruby/core_ext/array"
require "scruby/core_ext/delegator_array"


include Scruby
include Ugens

class MockUgen < Ugen
  class << self; public :new; end
end

class SinOsc < Ugen
  class << self
    def ar freq = 440.0, phase = 0.0 #not interested in muladd by now
      new :audio, freq, phase
    end
    
    def kr freq = 440.0, phase = 0.0
      new :control, freq, phase
    end
  end
end

class Scruby::Buffer
  def as_ugen_input; 0; end
end
    

describe Ugen do
  
  before do
    @sdef = mock 'sdef', :children => []
  end

  it "should set constants " do
    UgenOperations::UNARY.should_not be_nil
    UgenOperations::BINARY.should_not be_nil
    Ugen::RATES.should_not be_nil
  end
  
  it "should tell if valid input" do
    cn = ControlName.new 'cn', 1, :audio, 0
    Ugen.valid_input?( 440 ).should       be_true
    Ugen.valid_input?( 440.0 ).should     be_true
    Ugen.valid_input?( [4,4] ).should     be_true
    Ugen.valid_input?( SinOsc.ar ).should be_true
    Ugen.valid_input?( SinOsc.ar ).should be_true
    Ugen.valid_input?( Env.asr ).should   be_true
    Ugen.valid_input?( cn ).should        be_true
    Ugen.valid_input?( 'string' ).should  be_false
  end
  
  it "should use buffnum as input when a buffer is passed" do
    MockUgen.new( :audio, Buffer.new ).inputs.should == [0]
  end

  describe 'attributes' do
    before do
      @ugen = SinOsc.ar
    end
    
    it do
      @ugen.should respond_to( :inputs )
    end
    
    it do
      @ugen.should respond_to( :rate )
    end
  end

  describe 'operations' do
    before :all do
      @op_ugen    = mock( 'op_ugen' )
      UnaryOpUGen = mock 'unary_op_ugen',  :new => @op_ugen
    end
    
    before do
      @ugen  = SinOsc.ar
      @ugen2 = SinOsc.ar
    end
    
    it do #this specs all binary operations
      @ugen.should respond_to( :+ )
    end
    
    it "should sum" do
      (@ugen + @ugen2).should be_a(BinaryOpUGen)
    end
  end
  
  describe 'ugen graph in synth def' do
    before do
      Ugen.synthdef = nil
      @ugen  = MockUgen.new( :audio, 1, 2 )
      @ugen2 = MockUgen.new( :audio, 1, 2 )
    end
        
    it "should not have synthdef" do
      MockUgen.new( :audio, 1, 2 ).send( :synthdef ).should be_nil
    end
    
    it "should have 0 as index if not belonging to ugen" do
      MockUgen.new( :audio, 1, 2 ).index.should be_zero
    end
    
    it "should have synthdef" do
      Ugen.synthdef = @sdef
      @ugen.send( :synthdef ).should == @sdef
    end
    
    it do
      @ugen.should_not respond_to(:add_to_synthdef) #private method
    end
    
    it "should add to synth def on instantiation" do
      Ugen.synthdef = @sdef
      ugen = MockUgen.new( :audio, 1, 2)
      ugen.send( :synthdef ).should == @sdef
      @sdef.children.should == [ugen]
    end
    
    it "should add to synthdef and return synthdef.children size" do
      Ugen.synthdef = @sdef
      ugen, ugen2 = MockUgen.new(:audio, 1, 2), MockUgen.new(:audio, 1, 2)
      @sdef.children.should eql( [ugen, ugen2] )
      ugen.index.should == 0
      ugen2.index.should == 1
    end
    
    it "should not add to synthdef" do
      Ugen.synthdef = nil
      @sdef.children.should_not_receive( :<< )
      MockUgen.new( :audio, 1, 2 ).send( :add_to_synthdef ).should eql( nil )
    end
    
    it "should collect constants" do
      MockUgen.new( :audio, 100, @ugen, 200 ).send( :collect_constants ).flatten.sort.should == [1, 2, 100, 200]
    end
    
    it "should collect constants on arrayed inputs" do
      MockUgen.new( :audio, 100, [@ugen, [200, @ugen2, 100] ] ).send( :collect_constants ).flatten.uniq.sort.should == [1, 2, 100, 200]
    end
    
  end
  
  describe 'initialization and inputs' do
    before do
      @ugen = MockUgen.new(:audio, 1, 2, 3)
    end
    
    it "should not accept non valid inputs" do
      lambda{ @ugen = MockUgen.new(:audio, "hola") }.should raise_error( ArgumentError )
    end
    
    it "should require at least one argument" do
      lambda { MockUgen.new }.should raise_error( ArgumentError )
    end
    
    it "should be a defined rate as the first argument" do
      lambda { MockUgen.new( :not_a_rate, 1 ) }.should raise_error( ArgumentError )
    end
    
    it "should use the highest rate when passing an array" do
      MockUgen.new([:audio, :control], 1).rate.should == :audio
    end
    
    it "should be a defined rate as array" do
      lambda { MockUgen.new( [:not_a_rate, :audio], 1 ) }.should raise_error( ArgumentError )
    end
    
    it "should accept an empty array for inputs and inputs should be an empty array" do
      MockUgen.new( :audio, [] ).inputs.should eql([])
    end
    
    it "should instantiate" do
      MockUgen.new( :audio, 1, 2 ).should be_instance_of( MockUgen )
    end
    
    it "should accept any number of args" do
      MockUgen.new( :audio, 1, 2 )
      MockUgen.new( :audio, 1, 2, 3, 4 )
    end
    
    it "should set inputs" do
      @ugen.inputs.should == [1, 2, 3]
    end
    
    it "should set rate" do
      @ugen.rate.should == :audio
    end
    
    it "should have empty inputs" do
      MockUgen.new( :audio ).inputs.should == []
      MockUgen.new( :audio, [] ).inputs.should == []
    end
  end
  
  describe 'initialization with array as argument' do
    
    before :all do
      @i_1 = 100, 210 
      @i_2 = 100, 220 
      @i_3 = 100, 230 
      @i_4 = 100, 240
    end
    
    it "should not care if an array was passed" do
      MockUgen.new( :audio, [1, 2, 3] ).should be_instance_of(MockUgen)
    end
    
    it "should return an array of Ugens if an array as one arg is passed on instantiation" do
      MockUgen.new( :audio, 1, [2, 3] ).should be_instance_of(DelegatorArray)
    end
    
    it do
      MockUgen.new( :audio, 1, [2,3], [4,5] ).should have( 2 ).items
    end
    
    it do
      MockUgen.new( :audio, 1, [2,3, 3], [4,5] ).should have( 3 ).items
    end
    
    it "should return an array of ugens" do
      ugens = MockUgen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.each do |u|
        u.should be_instance_of(MockUgen)
      end
    end
    
    it "should return ugen" do
      ugen = MockUgen.new( :audio, [1], [2] )
      ugen.should be_instance_of( MockUgen )
      ugen.inputs.should == [1, 2]
    end
    
    it "should return ugen" do
      ugen = MockUgen.new( :audio, [1, 2] )
      ugen.should be_instance_of( MockUgen )
      ugen.inputs.should == [1, 2]
    end
    
    it "should make multichannel array (DelegatorArray)" do
      multichannel = MockUgen.new( :audio, 100, [210, 220] )
      multichannel.should be_a(DelegatorArray)
      multichannel.should == d(MockUgen.new(:audio, 100, 210), MockUgen.new(:audio, 100, 220))
    end
    
    it "should accept DelegatorArray as inputs" do
      multichannel = MockUgen.new( :audio, 100, d(210, 220) )
      multichannel.should be_a(DelegatorArray)
      multichannel.should == d(MockUgen.new(:audio, 100, 210), MockUgen.new(:audio, 100, 220))
    end
    
    it "should return an delegator array of ugens with correct inputs" do
      ugens = MockUgen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.zip( [@i_1, @i_2, @i_3, @i_4] ).each do |e|
        e.first.inputs.should eql( e.last )
      end
    end
    
    it "should match the structure of the inputs array(s)" do
      array = [ 200, [210, [220, 230] ] ]
      ugens = MockUgen.new( :audio, 100, array )
      last = lambda do |i| 
        if i.instance_of?(MockUgen) 
          i.inputs.first.should == 100
          i.inputs.last 
        else 
          i.map{ |e| last.call(e) } 
        end
      end
      last.call(ugens).should == array
    end
  
    it "should return muladd" do
      @ugen = MockUgen.new(:audio, 100, 100)
      @ugen.muladd(0.5, 0.5).should be_a(MulAdd)
    end
    
    it "should return an arrayed muladd" do
      @ugen = MockUgen.new(:audio, [100,100], 100)
      @ugen.muladd(0.5, 0.5).should be_a(DelegatorArray)
    end
  end
  
  describe Ugen, 'encoding' do
    before do
      args = [400.0, 0.0]
      @sin = SinOsc.kr *args
      @synthdef = mock 'synthdef', :constants => args
      @sin.stub!( :index ).and_return 1 #as if was the first child of a synthdef
      @sin.stub!( :synthdef ).and_return @synthdef

      @encoded = [6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 1].pack('C*')
    end

    it "should stub synthdef" do
      @sin.send( :synthdef ).should == @synthdef
    end

    it "should encode have 0 as special index" do
      @sin.send(:special_index).should == 0
    end

    it "should encode have 0 as output index" do
      @sin.send(:output_index).should == 0
    end

    it "should encode have [1] as output index" do
      @sin.send(:channels).should == [1]
    end

    it "should return input_specs" do
      @sin.send( :input_specs, nil ).should == [1,0]
    end

    it "should collect input_specs" do
      @sin.send(:collect_input_specs).should == [[-1, 0], [-1, 1]]
    end

    it "should encode class name" do
      @sin.encode[0..6].should == @encoded[0..6]
    end

    it "should encode classname, rate" do
      @sin.encode[0..7].should == @encoded[0..7]
    end

    it "should encode cn, rt, inputs, channels, special_index" do
      @sin.encode[0..13].should == @encoded[0..13]
    end

    it "should encode cn, rt, in, out, si, collect_input_specs" do
      @sin.encode.should == @encoded
    end
    
    it "should equal to a similar" do
      MockUgen.new(:audio, 1, 2).should == MockUgen.new(:audio, 1, 2)
    end
  end
end



