require File.join( File.expand_path(File.dirname(__FILE__)), "helper")
require "#{SCRUBY_DIR}/typed_array" 

class Type
end

describe TypedArray do
  
  before do
    @t1 = Type.new
    @t2 = Type.new
  end
  
  it "should initialize with attributes" do
    objs = (0..3).map{ Type.new }
    ta   = TypedArray.new( Type, objs )
    ta.type.should == Type
    ta.should == objs
  end
  
  it "should instantiate with an array" do
    objs = (0..3).map{ Type.new }
    ta   = TypedArray.new( Type, objs )
    ta.should == objs
  end
  
  it "set type by instance" do
    ta = TypedArray.new( Type.new )
    ta.type.should == Type
  end
  
  it "should raise error if wrong type" do
    lambda{ TypedArray.new(Type, 1) }.should raise_error(TypeError)
  end
  
  it "+ success" do
    ta = TypedArray.new( Type )
    o = Type.new
    sum = ta + [o]
    sum.should be_instance_of(TypedArray)
    sum.should == [o]
  end
  
  it "+ failure" do
    lambda{ TypedArray.new(Type, Type.new) + [1] }.should raise_error(TypeError)
  end
  
  it "concat success" do
    ta = TypedArray.new( Type, [@t1] )
    ta.concat( [@t2] ).should == ta
    ta.should == [@t1,@t2]
  end
  
  it "concat failure" do
    lambda{ TypedArray.new(Type, Type.new).concat( 1 ) }.should raise_error(TypeError)
    lambda{ TypedArray.new(Type, Type.new).concat( [1] ) }.should raise_error(TypeError)
  end
  
  it "<< success" do
    ta = TypedArray.new(Type) << @t1
    ta.should == [@t1]
  end
  
  it "<< failure" do
    lambda{ TypedArray.new(Type, Type.new) << [1] }.should raise_error(TypeError)
  end
  
  it "[]= success" do
    ta = TypedArray.new(Type)
    ta[0]= @t1
    ta[0].should == @t1
  end
  
  it "[]= failure" do
    lambda{ TypedArray.new(Type, Type.new)[0]= 1 }.should raise_error(TypeError)
  end
  
  it "push success" do
    ta = TypedArray.new(Type)
    ta.push( @t1 )
    ta.should == [@t1]
  end
  
  it "push failure" do
    lambda{ TypedArray.new(Type, Type.new).push(1) }.should raise_error(TypeError)
  end
  
  it "should convert to array" do
    ta = TypedArray.new(Type)
    ta.to_a.should be_instance_of(Array)
  end

end


