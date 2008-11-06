require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'
 
require "#{LIB_DIR}/audio/ugens/ugen_operations" 
require "#{LIB_DIR}/audio/ugens/ugen" 
require "#{LIB_DIR}/extensions"

include Scruby
include Audio
include Ugens


class SinOsc < Ugen
  class << self
    def ar( freq=440.0, phase=0.0 ) #not interested in muladd
      new(:audio, freq, phase)
    end
    
    def kr( freq=440.0, phase=0.0 ) 
      new(:control, freq, phase)
    end
  end
end
    

describe Ugen do
  
  before do
    @sdef = mock( 'sdef', :children => [] )
  end

  it "should set constants " do
    UgenOperations::UNARY.should_not be_nil
    UgenOperations::BINARY.should_not be_nil
    Ugen::RATES.should_not be_nil
  end

  describe 'attributes' do
    
    before do
      @ugen = Ugen.new( :audio, 1 )
    end
    
    it do
      @ugen.should respond_to( :inputs )
    end
    
    it do
      @ugen.should respond_to( :rate )
    end
    
    it do
      @ugen.should be_ugen
    end
  end

  describe 'operations' do
    before :all do
      @op_ugen = mock( 'op_ugen', :ugen? => true )
      BinaryOpUGen = mock( 'bynary_op_ugen', :new => @op_ugen )
      UnaryOpUgen  = mock( 'unary_op_ugen', :new => @op_ugen )
    end
    
    before do
      @ugen  = Ugen.new( :audio, 1, 2 )
      @ugen2 = Ugen.new( :audio, 1, 2 )
    end
    
    it do #this specs all binary operations
      @ugen.should respond_to( :+ )
    end
    
    it "should sum" do
      BinaryOpUGen.should_receive( :new ).with( :+, @ugen, @ugen2)
      @ugen + @ugen2
    end
  end
  
  describe 'ugen graph in synth def' do
    before do
      Ugen.synthdef = nil
      @ugen  = Ugen.new( :audio, 1, 2 )
      @ugen2 = Ugen.new( :audio, 1, 2 )
    end
        
    it "should not have synthdef" do
      Ugen.new( :audio, 1, 2 ).send( :synthdef ).should be_nil
    end
    
    it "should have 0 as index if not belonging to ugen" do
      Ugen.new( :audio, 1, 2 ).index.should be_zero
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
      ugen = Ugen.new( :audio, 1, 2)
      ugen.send( :synthdef ).should == @sdef
      @sdef.children.should == [ugen]
    end
    
    it "should add to synthdef and return synthdef.children size" do
      Ugen.synthdef = @sdef
      ugen, ugen2 = Ugen.new(:audio, 1, 2), Ugen.new(:audio, 1, 2)
      @sdef.children.should eql( [ugen, ugen2] )
      ugen.index.should == 0
      ugen2.index.should == 1
    end
    
    it "should not add to synthdef" do
      Ugen.synthdef = nil
      @sdef.children.should_not_receive( :<< )
      Ugen.new( :audio, 1, 2 ).send( :add_to_synthdef ).should eql( nil )
    end
    
    it "should collect constants" do
      Ugen.new( :audio, 100, @ugen, 200 ).send( :collect_constants ).flatten.sort.should == [1, 2, 100, 200]
    end
    
    it "should collect constants on arrayed inputs" do
      Ugen.new( :audio, 100, [@ugen, [200, @ugen2, 100] ] ).send( :collect_constants ).flatten.uniq.sort.should == [1, 2, 100, 200]
    end
    
  end
  
  describe 'initialization' do
    before do
      @ugen = Ugen.new(:audio, 1, 2, 3)
    end
    
    it "should not accept non valid inputs" do
      lambda{ @ugen = Ugen.new(:audio, "hola") }.should raise_error( ArgumentError )
    end
    
    it "should require at least one argument" do
      lambda { Ugen.new }.should raise_error( ArgumentError )
    end
    
    it "should be a defined rate as the first argument" do
      lambda { Ugen.new( :not_a_rate, 1 ) }.should raise_error( ArgumentError )
    end
    
    it "should accept an empty array for inputs and inputs should be an empty array" do
      Ugen.new( :audio, [] ).inputs.should eql([])
    end
    
    it "should instantiate" do
      Ugen.new( :audio, 1, 2 ).should be_instance_of( Ugen )
    end
    
    it "should accept any number of args" do
      Ugen.new( :audio, 1, 2 )
      Ugen.new( :audio, 1, 2, 3, 4 )
    end
    
    it "should description" do
      Ugen.should_receive( :instantiate ).with( :audio, 1, 2 )
      Ugen.new( :audio, 1, 2 )
    end
    
    it "should set inputs" do
      @ugen.inputs.should == [1, 2, 3]
    end
    
    it "should set rate" do
      @ugen.rate.should == :audio
    end
    
    it "should have empty inputs" do
      Ugen.new( :audio ).inputs.should == []
      Ugen.new( :audio, [nil] ).inputs.should == []
    end
  end
  
  describe 'initialization with array as argument' do
    
    before :all do
      *@i_1 = 100, 210 
      *@i_2 = 100, 220 
      *@i_3 = 100, 230 
      *@i_4 = 100, 240
    end
    
    it "should not care if an array was passed" do
      Ugen.new( :audio, [1, 2, 3] ).should be_instance_of(Ugen)
    end
    
    it "should return an array of Ugens if an array as one arg is passed on instantiation" do
      Ugen.new( :audio, 1, [2, 3] ).should be_instance_of(Array)
    end
    
    it do
      Ugen.new( :audio, 1, [2,3], [4,5] ).should have( 2 ).items
    end
    
    it do
      Ugen.new( :audio, 1, [2,3, 3], [4,5] ).should have( 3 ).items
    end
    
    it "should return an array of ugens" do
      ugens = Ugen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.each do |u|
        u.should be_instance_of(Ugen)
      end
    end
    
    it "should return ugen" do
      ugen = Ugen.new( :audio, [1], [2] )
      ugen.should be_instance_of( Ugen )
      ugen.inputs.should == [1, 2]
    end
    
    it "should return ugen" do
      ugen = Ugen.new( :audio, [1, 2] )
      ugen.should be_instance_of( Ugen )
      ugen.inputs.should == [1, 2]
    end
    
    it "should instantiate when passing array" do
      Ugen.should_receive(:instantiate).twice
      ugen = Ugen.new( :audio, 100, [210, 220] )
    end
    
    it "should instantiate with correct arguments" do
      Ugen.should_receive(:instantiate).with( :audio, *@i_1 )
      Ugen.should_receive(:instantiate).with( :audio, *@i_2 )
      Ugen.should_receive(:instantiate).with( :audio, *@i_3 )
      Ugen.should_receive(:instantiate).with( :audio, *@i_4 )
      ugens = Ugen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.should have(4).ugens
    end
    
    it "should return an array of ugens with correct inputs" do
      ugens = Ugen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.zip( [@i_1, @i_2, @i_3, @i_4] ).each do |e|
        e.first.inputs.should eql( e.last )
      end
    end
    
    it "should match the structure of the inputs array(s)" do
      array = [ 200, [210, [220, 230] ] ]
      ugens = Ugen.new( :audio, 100, array )
      last = lambda do |i| 
        if i.instance_of?(Ugen) 
          i.inputs.first.should == 100
          i.inputs.last 
        else 
          i.map{ |e| last.call(e) } 
        end
      end
      last.call(ugens).should == array
    end
  
    it "should return muladd" do
      MulAdd = mock( 'MulAdd', :new => nil )
      @ugen = Ugen.new(:audio, 100, 100)
      MulAdd.should_receive( :new ).with( @ugen, 1, 1)
      @ugen.muladd(1, 1).should be_nil
    end
  end

  
end

describe Ugen, 'encoding' do
  
  before do
    args = [400.0, 0.0]
    @sin = SinOsc.kr(*args)
    @synthdef = mock('synthdef', :constants => args )
    @sin.stub!(:index).and_return(1) #as if was the first child of a synthdef
    @sin.stub!( :synthdef ).and_return( @synthdef )
    
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
  
  it "should collect input_specs" do
    @sin.send(:collect_input_specs).flatten.collect { |e| e.encode }
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
    
  
end


