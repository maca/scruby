require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'

require "#{SCRUBY_DIR}/audio/ugens/ugen_operations" 
require "#{SCRUBY_DIR}/audio/ugens/ugen" 
require "#{SCRUBY_DIR}/extensions"
require "#{SCRUBY_DIR}/audio/ugens/operation_ugens"

include Scruby
include Audio
include Ugens
include OperationUgens

describe UnaryOpUgen do
  ::RATES = :scalar, :demand, :control, :audio
  
  before do
    @scalar  = mock 'ugen', :rate => :scalar,  :valid_ugen_input? => true
    @demand  = mock 'ugen', :rate => :demand,  :valid_ugen_input? => true
    @control = mock 'ugen', :rate => :control, :valid_ugen_input? => true
    @audio   = mock 'ugen', :rate => :audio,   :valid_ugen_input? => true
  end
  
  describe UnaryOpUgen do
    
    before do
      @op = UnaryOpUgen.new( :neg, @audio )
    end
    
    it "should return special index" do
      UnaryOpUgen.new( :neg, @audio ).special_index.should     == 0
      UnaryOpUgen.new( :bitNot, @audio ).special_index.should  == 4
      UnaryOpUgen.new( :abs, @audio ).special_index.should     == 5
      UnaryOpUgen.new( :asFloat, @audio ).special_index.should == 6
    end
  
    it "should accept just one input" do
      lambda{ UnaryOpUgen.new(:neg, @audio, @demand) }.should raise_error ArgumentError
    end
  
    it "should just accept defined operators" # do
     #    lambda{ UnaryOpUgen.new(:not_operator, @audio) }.should raise_error( ArgumentError )
     #  end
  
    it "should get max rate" do
      UnaryOpUgen.send(:get_rate, @scalar, @demand ).should                       == :demand
      UnaryOpUgen.send(:get_rate, @scalar, @demand, @audio ).should               == :audio
      UnaryOpUgen.send(:get_rate, @scalar, [@demand, [@control, @audio]] ).should == :audio
    end
  
    it do
      UnaryOpUgen.new(:neg, @audio).should be_instance_of(UnaryOpUgen)
    end
  
    it "should set rate" do
      UnaryOpUgen.new(:neg, @audio).rate.should  == :audio
      UnaryOpUgen.new(:neg, @scalar).rate.should == :scalar
    end
  
    it "should set operator" do
      UnaryOpUgen.new(:neg, @audio).operator.should == :neg
    end    
  end
  
  describe BinaryOpUGen do
    
    before do
      @arg_array = [@audio, [@scalar, @audio, [@demand, [@control, @demand]]] ]
      @op_arr = BinaryOpUGen.new(:+, @audio, @arg_array )
    end
    
    it "should return special index" do
      BinaryOpUGen.new( :+, @audio, @audio ).special_index.should == 0
      BinaryOpUGen.new( :-, @audio, @audio ).special_index.should == 1
      BinaryOpUGen.new( :*, @audio, @audio ).special_index.should == 2
      BinaryOpUGen.new( :/, @audio, @audio ).special_index.should == 4
    end
  
    it "should accept exactly two inputs" do
      lambda{ BinaryOpUGen.new(:+, @audio) }.should raise_error( ArgumentError )
      lambda{ BinaryOpUGen.new(:+, @audio, @demand, @demand) }.should raise_error( ArgumentError )
    end

    it "should have correct inputs and operator when two inputs" do
      arr = BinaryOpUGen.new( :+, @audio, @demand )
      arr.inputs.should == [@audio, @demand]
      arr.operator.should == :+
      arr.rate.should == :audio
    end
  
    it "should accept array as input" do
      BinaryOpUGen.new(:+, @audio, [@audio, @scalar] ).should be_instance_of(Array)
    end
  
    it "should return an array of UnaryOpUgens" do
      @op_arr.flatten.map { |op| op.should be_instance_of(BinaryOpUGen)  }
    end
  
    it "should set rate for all operations" do
      @op_arr.flatten.map { |op| op.rate.should eql(:audio)  }
    end
  
    it "should set operator for all operations" do
      @op_arr.flatten.map { |op| op.operator.should eql(:+)  }
    end
  
    it "should set correct inputs when provided an array" do
      arr = BinaryOpUGen.new(:+, @control, [@audio, @scalar] )
      arr.first.inputs.should == [@control, @audio]
      arr.last.inputs.should  == [@control, @scalar]
    end
    
    it "should create the correct number of operations" do
      @op_arr.flatten.size.should eql( @arg_array.flatten.size )
    end
  
    it "should replicate the array passed" do
      last = lambda do |i| 
        if i.instance_of?( BinaryOpUGen) 
          i.inputs.first.should == @audio
          i.inputs.last 
        else 
          i.map{ |e| last.call(e) } 
        end
      end
      last.call(@op_arr).should == @arg_array
    end
    
    it "should accept numbers as inputs" do
      arr = BinaryOpUGen.new(:+, @control, [100, 200.0] )
      arr.first.inputs.should == [@control, 100]
      arr.last.inputs.should  == [@control, 200.0]
      BinaryOpUGen.new(:+, 100, @control ).inputs.should == [100, @control]
    end
    
    it "should accept array as input" do
      arr = BinaryOpUGen.new(:+, [@audio, @scalar], @control  )
      arr.first.inputs.should == [@audio, @control]
      arr.last.inputs.should  == [@scalar, @control]
    end
    
    it "should accept numeric arg as first arg" do
      arr = BinaryOpUGen.new(:+, 1, @control  )
      arr.inputs.should == [1, @control]
    end
  end
  
  describe MulAdd do
    it do
      MulAdd.new( @audio, 0.5, 0.5 ).should be_instance_of(MulAdd)
    end

    it do
      MulAdd.new( @audio, 0.5, 0.5 ).rate.should   == :audio
    end
    
    it do
      MulAdd.new( @audio, 0.5, 0.5 ).inputs.should == [@audio, 0.5, 0.5]
    end
    
    it "should not be instance of MulAdd" do
      unary_op = mock 'neg'
      mult     = mock 'mult'
      minus    = mock 'minus'
      plus     = mock 'plus'
      
      @audio.should_receive( :neg ).and_return( unary_op )
      @audio.should_receive( :* ).and_return( mult )
      add = mock( '0.5', :- => minus, :zero? => false )
      @audio.should_receive( :+ ).and_return( plus )
      
      MulAdd.new( @audio, 0, 0.5 ).should be_instance_of( Float )
      MulAdd.new( @audio, 1, 0 ).should   == @audio
      MulAdd.new( @audio, -1, 0 ).should  == unary_op
      MulAdd.new( @audio, 0.5, 0 ).should == mult
      MulAdd.new( @audio, -1, add ).should == minus
      MulAdd.new( @audio, 1, 0.5 ).should == plus
    end
    
    it "should accept ugens" do
      MulAdd.new( @audio, @audio, 1 ).should be_instance_of(MulAdd)
      MulAdd.new( @audio, @audio, @scalar ).should be_instance_of(MulAdd)
      
      bin_op_ugen = mock 'binary op ugen'
      @audio.stub!( :* ).and_return bin_op_ugen
      MulAdd.new( @audio, @audio, 0 ).should == bin_op_ugen
    end
        
  end
  
end

