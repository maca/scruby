require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'

require "#{SCRUBY_DIR}/audio/ugens/ugen"
require "#{SCRUBY_DIR}/audio/ugens/operation_ugens"
require "#{SCRUBY_DIR}/audio/ugens/ugen_operations" 
require "#{SCRUBY_DIR}/extensions"

include Scruby
include Audio
include Ugens

describe UgenOperations do
  
  before do
    @ugen = Ugen.new :audio
    @ugen2 = Ugen.new :audio
  end

  describe 'binary operations' do
    it "should sum" do
      sum = @ugen + @ugen2
      sum.should be_instance_of(BinaryOpUGen)
    end
    
    it 'should sum integer' do
      sum = @ugen + 1.0
      sum.should be_instance_of(BinaryOpUGen)
    end
    
    it "respond to #ugen_sum (it will override #+ but can't name a method old_+)" do
      @ugen.should respond_to( :__ugen_plus )
    end
    
    it "should raise argument error" do
      lambda { @ugen + :hola }.should raise_error( ArgumentError )
    end
  end
  
  describe 'unary operations' do
    it "should do unary op" do
      op = @ugen.distort

      op.should be_instance_of(UnaryOpUGen)
      op.inputs.should == [@ugen]
    end
  end
  
  describe Numeric do
    it do
      1.should respond_to( :ring4 )
      1.should respond_to( :__ugen_plus )
    end

    it do
      1.2.should respond_to( :ring4 )
    end

    it "should use original +" do
      sum = 1 + 1
      sum.should == 2
    end
    
    it "should return a BinarayOpUgen when adding an Ugen" do
      sum = 1 + @ugen
      sum.should be_instance_of(BinaryOpUGen)
    end
    
    it "should set the correct inputs and operator for the binopugen" do
      sum = 1.0 + @ugen
      sum.inputs.should == [1.0, @ugen]
      sum.operator.should == :+
    end
    
    it "ugen should sum numeric" do
      sum = @ugen + 1
      sum.should be_kind_of(BinaryOpUGen)
      sum.inputs.should == [@ugen, 1]
    end
    
    it 'ugen should sum array' do
      sum  = @ugen + [1,2]
      sum.should have(2).ugens
      sum.first.inputs.should == [@ugen, 1]
      sum.last.inputs.should  == [@ugen, 2]
    end
  end
  
  describe Array do
    it do
      [].should respond_to( :ring4 )
      [].should respond_to( :__ugen_plus )
    end
    
    it "should sum an ugen" do
      [] + @ugen
    end
    
    it "should sum arrays as expected" do
      sum = [1,2] + [3]
      sum.should == [1,2,3]
    end

    it "should return" do
      BinaryOpUGen.should_receive( :new ).with( :*, [1,2], @ugen )
      ([1, 2] * @ugen)
    end    
  end
  
end


# methods overriden by UgenOperations inclusion: 
# Fixnum#+ Fixnum#gcd Fixnum#/ Fixnum#round Fixnum#lcm Fixnum#div Fixnum#- Fixnum#>= Fixnum#* Fixnum#<= 
# Float#+ Float#/ Float#round Float#div Float#- Float#>= Float#* Float#<= 
# Array#+ Array#- Array#*
# changed max and min to maximum and minimum because the override Array#max and Array#min wich take no args


