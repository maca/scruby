require File.join( File.expand_path(File.dirname(__FILE__)),"helper")

require "#{LIB_DIR}/audio/ugens/ugen_operations"
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
  
  it "should #collect_constants" do
    1.send( :collect_constants ).should == 1
    1.5.send( :collect_constants ).should == 1.5
  end
  
  it "should spec #input_specs" do
    synthdef = mock('synthdef', :constants => [200.0,1,3, 400.0] )
    200.0.send( :input_specs, synthdef ).should == [-1,0]
    3.send( :input_specs, synthdef ).should == [-1,2]
    400.0.send( :input_specs, synthdef ).should == [-1,3]
  end
  
  it "should spec encode"
  
  
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
    
    it "should wrap and zip" do
      [:a,:b,:c].wrap_and_zip([1]).flatten.should == [:a,1,:b,1,:c,1]
      
       [0.5, 0.5].wrap_and_zip([3],[5]).flatten.should == [0.5,3,5,0.5,3,5]
       [0.01, 1.0].wrap_and_zip([-4.0],[5]).flatten.should ==  [0.01, -4.0, 5, 1.0, -4.0, 5]
    end
    
    it "should sum with Ugen"
    it "should collect constants"
    
    
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

describe String do
  
  it "should encode" do
    "SinOsc".encode.should == [6, 83, 105, 110, 79, 115, 99].pack('C*')
  end
  
  it "should encode large strings" do
    'set arguments cn.argNum << this is the size of controlNames when controlName was added'.encode.should ==
      [86, 115, 101, 116, 32, 97, 114, 103, 117, 109, 101, 110, 116, 115, 32, 99, 110, 46, 97, 114, 103, 78, 117, 109, 32, 60, 60, 32, 116, 104, 105, 115, 32, 105, 115, 32, 116, 104, 101, 32, 115, 105, 122, 101, 32, 111, 102, 32, 99, 111, 110, 116, 114, 111, 108, 78, 97, 109, 101, 115, 32, 119, 104, 101, 110, 32, 99, 111, 110, 116, 114, 111, 108, 78, 97, 109, 101, 32, 119, 97, 115, 32, 97, 100, 100, 101, 100].pack('C*')
  end
  
end


