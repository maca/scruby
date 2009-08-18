require File.expand_path(File.dirname(__FILE__)) + "/../helper"

require "scruby/core_ext/array"
require "scruby/core_ext/delegator_array"
require "scruby/env"
require "scruby/control_name"
require "scruby/ugens/ugen"
require "scruby/ugens/ugens"
require "scruby/ugens/ugen_operations"
require "scruby/ugens/operation_ugens"

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

# Mocks
class ControlName; end
class Env; end

describe DelegatorArray do
  
  it "should have 'literal' notation" do
    d(1,2).should   == [1,2]
    d(1,2).should be_instance_of(DelegatorArray)
    d([1,2]).should == d(1,2)
  end
  
  it "should allow nil" do
    d(nil)
  end
  
  it "should return DelegatorArray" do
    sig = SinOsc.ar([100, [100, 100]])
    sig.should be_a(DelegatorArray)
  end
  
  it "should convet to_da" do
    [].to_da.should be_a(DelegatorArray)
  end
  
  it "should pass missing method" do
    d(1,2).to_f.should == d(1.0,2.0)
  end
  
  it "should return a DelegatorArray for muladd" do
    SinOsc.ar(100).muladd(1, 0.5).should be_a(BinaryOpUGen)
    SinOsc.ar([100, [100, 100]]).muladd(0.5, 0.5).should be_a(DelegatorArray)
    # SinOsc.ar([100, [100, 100]]).muladd(1, 0.5).should be_a(DelegatorArray)
  end

  
  it "should pass method missing" do
    d(1,2,3).to_i.should == [1.0, 2.0, 3.0]
  end
  
  shared_examples_for 'aritmetic operand' do
    before do
      @numeric_op     = eval %{ d(1,2)   #{ @op } 3.0 }
      @array_op       = eval %{ d(1,2)   #{ @op } d(1.0, 2.0) }
      @asim_array_op1 = eval %{ d(1,2,3) #{ @op } d(1.0, 2.0) }
    end
    
    it "should do operation" do
      @numeric_op.should == @numeric_op
      @numeric_op.should be_a(DelegatorArray)
    end
    
    it "should do operation with array of the same size" do
      @array_op.should == @array_result
      @array_op.should be_a(DelegatorArray)
    end
    
    it "should do operation with array of diferent size (left bigger)" do
      @asim_array_op1.should == @asim_result1
      @asim_array_op1.should be_a(DelegatorArray)
    end
    
    it "should blow passing nil" do
      lambda { d(1,2,3,nil) + 1 }.should raise_error(NoMethodError)
    end
    
    it "should blow pass nil" do
      actual   = eval %{ d(1,2,3) #{ @op } MockUgen.new(:audio, 2)}
      expected = BinaryOpUGen.new(@op.to_sym, [1,2,3], MockUgen.new(:audio, 2) )
      actual.should == expected
    end

    it "should allow passing an MockUgen Array" do
      eval %{ SinOsc.ar([100, [100, 100]]) #{@op} SinOsc.ar }
    end
  end
  
  describe "should override sum" do
    before do
      @op           = '+'
      @array_result = d(1+1.0, 2+2.0)
      @asim_result1 = d(1+1.0, 2+2.0, 3)
    end
    it_should_behave_like 'aritmetic operand'
  end
  
  describe "should override subs" do
    before do
      @op           = '-'
      @array_result = d(1-1.0, 2-2.0)
      @asim_result1 = d(1-1.0, 2-2.0, 3)
    end
  end
  
  describe "should override mult" do
    before do
      @op           = '*'
      @array_result = d(1*1.0, 2*2.0)
      @asim_result1 = d(1*1.0, 2*2.0, 3)
    end
    it_should_behave_like 'aritmetic operand'
  end
  
  describe "should override div" do
    before do
      @op           = '/'
      @array_result = d(1/1.0, 2/2.0)
      @asim_result1 = d(1/1.0, 2/2.0, 3)
    end
    it_should_behave_like 'aritmetic operand'
  end

end