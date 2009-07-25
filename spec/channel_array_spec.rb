require File.join( File.expand_path(File.dirname(__FILE__)), "helper")
require "scruby/core_ext/array"
require "scruby/core_ext/delegator_array"


describe DelegatorArray do
  
  it "should have 'literal' notation" do
    d(1,2).should   == [1,2]
    d(1,2).should be_instance_of(DelegatorArray)
    d([1,2]).should == d(1,2)
  end
  
  it "should allow nil" do
    d(nil)
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
    
    it "should blow pass nil" do
      lambda { d(nil,2,3) + 1 }.should raise_error(NoMethodError)
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