RSpec.describe Numeric do
  before :all do
    @bin_op = double "binop"
    ::BinaryOpUGen = double "BinaryOpUGen", new: @bin_on
    @ugen          = double "ugen"
    ::Ugen         = double "Ugen", new: @ugen
  end

  it "shoud have an scalar rate" do
    expect(1.rate).to eq(:scalar)
  end

  it "should have an scalar rate" do
    expect(100.0.rate).to eq(:scalar)
  end

  it "sum as usual" do
    expect(100 + 100).to eq(200)
  end

  it "should #collect_constants" do
    expect(1.send( :collect_constants )).to   eq(1)
    expect(1.5.send( :collect_constants )).to eq(1.5)
  end

  it "should spec #input_specs" do
    synthdef = double("synthdef", constants: [200.0, 1, 3, 400.0] )
    expect(200.0.send( :input_specs, synthdef )).to eq([-1, 0])
    expect(3.send( :input_specs, synthdef )).to eq([-1, 2])
    expect(400.0.send( :input_specs, synthdef )).to eq([-1, 3])
  end

  it "should spec encode"
end


RSpec.describe Proc do
  describe "#arguments" do

    it do
      expect{}.to respond_to( :arguments )
    end

    it "should get empty array if proc has no args" do
      expect(proc{}.arguments).to eql( [] )
    end

    it "should get one argument name" do
      expect(proc{ |arg|  }.arguments).to eql( [ :arg ] )
    end

    it "should get arg names with several args" do
      expect(proc{ |arg, arg2, arg3|  }.arguments).to eql( [ :arg, :arg2, :arg3 ] )
    end
  end
end

RSpec.describe Array, "monkey patches" do
  describe "#collect_with_index" do
    it do
      expect([]).to respond_to( :collect_with_index )
    end

    it "should return an array the same size as the original" do
      expect([1, 2, 3, 4].collect_with_index{ nil }.size).to eq(4)
    end

    it "should collect_with_index" do
      array = %w(a, b, c, d)
      expect(array.collect_with_index{ |element, index| [index, element] }).to eql( [0, 1, 2, 3].zip( array ) )
    end

    it "should wrap and zip" do
      expect([:a, :b, :c].wrap_and_zip([1]).flatten).to eq([:a, 1, :b, 1, :c, 1])
      expect([0.5, 0.5].wrap_and_zip([3], [5]).flatten).to eq([0.5, 3, 5, 0.5, 3, 5])
      expect([0.01, 1.0].wrap_and_zip([-4.0], [5]).flatten).to eq([0.01, -4.0, 5, 1.0, -4.0, 5])
    end
  end

  describe "#wrap_to" do
    it do
      expect(Array.new).to respond_to( :wrap_to )
    end

    it "should wrap_to!" do
      expect([1, 2].wrap_to!(4)).to eq([1, 2, 1, 2])
    end

    it do
      expect(Array.new).to respond_to( :wrap_to )
    end

    it "should return self if the passed size is the same as self.size" do
      a = [1, 2, 3, 4]
      expect(a.wrap_to( 4 )).to eq(a)
    end
  end

  it "should sum with Ugen"
  it "should collect constants"
end

RSpec.describe String do
  it "should encode" do
    expect("SinOsc".encode).to eq([6, 83, 105, 110, 79, 115, 99].pack("C*"))
  end

  it "should encode large strings" do
    expect("set arguments cn.argNum << this is the size of controlNames when controlName was added".encode).to eq(
      [86, 115, 101, 116, 32, 97, 114, 103, 117, 109, 101, 110, 116, 115, 32, 99, 110, 46, 97, 114, 103, 78, 117, 109, 32, 60, 60, 32, 116, 104, 105, 115, 32, 105, 115, 32, 116, 104, 101, 32, 115, 105, 122, 101, 32, 111, 102, 32, 99, 111, 110, 116, 114, 111, 108, 78, 97, 109, 101, 115, 32, 119, 104, 101, 110, 32, 99, 111, 110, 116, 114, 111, 108, 78, 97, 109, 101, 32, 119, 97, 115, 32, 97, 100, 100, 101, 100].pack("C*")
    )
  end

end
