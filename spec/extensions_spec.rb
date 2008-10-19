require File.join(File.expand_path(File.dirname(__FILE__)),"helper")

require "#{LIB_DIR}/extensions"
require "ruby2ruby"

describe Numeric do
  
  before :all do
    @bin_op = mock('binop')
    BinaryOpUgen = mock( 'BinaryOpUgen', :new => @bin_on )
    @ugen = mock( 'ugen' )
    Ugen = mock( 'Ugen', :new => @ugen)
    
    
  end
  
  it "shoud have an scalar rate" do
    1.rate.should eql(:scalar)
  end
  
  it "should have an scalar rate" do
    100.0.rate.should == :scalar
  end
  
  it "sum as usual" do
    (100 + 100).should == 200 
  end
  
end

describe Array, "monkey patches" do
  describe "#collect_with_index" do
    it do
      [].should respond_to( :collect_with_index )
    end
    
    it "should return an array the same size as the original" do
      [1,2,3,4].collect_with_index{ nil }.should have( 4 ).items
    end
    
    it "should collect_with_index" do
      array = %w(a, b, c, d)
      array.collect_with_index{ |element, index| [index, element] }.should eql( [0,1,2,3].zip( array ) )
    end
    
    it "should sum with Ugen"
    
  end
end

describe Proc do
  describe "#argument_names" do
    
    it do
      Proc.new{}.should respond_to( :argument_names )
    end
    
    it "should get empty array if proc has no args" do
      Proc.new{}.argument_names.should eql( [] )
    end
    
    it "should get one argument name" do
      Proc.new{ |arg|  }.argument_names.should eql( [ :arg ] )
    end
    
    it "should get arg names with several args" do
      Proc.new{ |arg, arg2, arg3|  }.argument_names.should eql( [ :arg, :arg2, :arg3 ] )
    end
  end
end

describe Array do
  describe "#wrap_to" do
    
    it do
      Array.new.should respond_to( :wrap_to )
    end
    
    it "should wrap_to!" do
      [1,2].wrap_to!(4).should == [1,2,1,2]
    end
    
    it do
      Array.new.should respond_to( :wrap_to )
    end
    
    it "should return self if the passed size is the same as self.size" do
      a = [1,2,3,4]
      a.wrap_to( 4 ).should == a
    end
    
    it "should etc..."
    
  end
end


