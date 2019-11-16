class Type
end

RSpec.describe TypedArray do

  before do
    @t1 = Type.new
    @t2 = Type.new
  end

  it "should initialize with attributes" do
    objs = (0..3).map{ Type.new }
    ta   = TypedArray.new( Type, objs )
    expect(ta.type).to eq(Type)
    expect(ta).to      eq(objs)
  end

  it "should instantiate with an array" do
    objs = (0..3).map{ Type.new }
    ta   = TypedArray.new( Type, objs )
    expect(ta).to eq(objs)
  end

  it "set type by instance" do
    ta = TypedArray.new( Type.new )
    expect(ta.type).to eq(Type)
  end

  it "should raise error if wrong type" do
    expect{ TypedArray.new(Type, 1) }.to raise_error(TypeError)
  end

  it "+ success" do
    ta  = TypedArray.new( Type )
    o   = Type.new
    sum = ta + [o]
    # sum.should be_instance_of(TypedArray)
    expect(sum).to eq([o])
  end

  it "+ failure" do
    expect{ TypedArray.new(Type, Type.new) + [1] }.to raise_error(TypeError)
  end

  it "concat success" do
    ta = TypedArray.new( Type, [@t1] )
    expect(ta.concat( [@t2] )).to eq(ta)
    expect(ta).to eq([@t1, @t2])
  end

  it "concat failure" do
    expect{ TypedArray.new(Type, Type.new).concat( 1 ) }.to raise_error(TypeError)
    expect{ TypedArray.new(Type, Type.new).concat( [1] ) }.to raise_error(TypeError)
  end

  it "<< success" do
    ta = TypedArray.new(Type) << @t1
    expect(ta).to eq([@t1])
  end

  it "<< failure" do
    expect{ TypedArray.new(Type, Type.new) << [1] }.to raise_error(TypeError)
  end

  it "[]= success" do
    ta = TypedArray.new(Type)
    ta[0] = @t1
    expect(ta[0]).to eq(@t1)
  end

  it "[]= failure" do
    expect{ TypedArray.new(Type, Type.new)[0] = 1 }.to raise_error(TypeError)
  end

  it "push success" do
    ta = TypedArray.new(Type)
    ta.push( @t1 )
    expect(ta).to eq([@t1])
  end

  it "push failure" do
    expect{ TypedArray.new(Type, Type.new).push(1) }.to raise_error(TypeError)
  end

  it "should convert to array" do
    ta = TypedArray.new(Type)
    expect(ta.to_a).to be_instance_of(Array)
  end

end
