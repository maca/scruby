include Scruby
include Ugens

class MockUgen < Ugen
  class << self; public :new; end
end

class SinOsc < Ugen
  class << self
    def ar(freq = 440.0, phase = 0.0) # not interested in muladd by now
      new :audio, freq, phase
    end

    def kr(freq = 440.0, phase = 0.0)
      new :control, freq, phase
    end
  end
end

class Scruby::Buffer
  def as_ugen_input; 0; end
end


RSpec.describe Ugen do

  before do
    @sdef = double "sdef", children: []
  end

  it "should set constants " do
    expect(UgenOperations::UNARY).not_to be_nil
    expect(UgenOperations::BINARY).not_to be_nil
    expect(Ugen::RATES).not_to be_nil
  end

  it "should tell if valid input" do
    cn = ControlName.new "cn", 1, :audio, 0
    expect(Ugen.valid_input?( 440 )).to       be_truthy
    expect(Ugen.valid_input?( 440.0 )).to     be_truthy
    expect(Ugen.valid_input?( [4, 4] )).to be_truthy
    expect(Ugen.valid_input?( SinOsc.ar )).to be_truthy
    expect(Ugen.valid_input?( SinOsc.ar )).to be_truthy
    expect(Ugen.valid_input?( Env.asr )).to   be_truthy
    expect(Ugen.valid_input?( cn )).to        be_truthy
    expect(Ugen.valid_input?( "string" )).to  be_falsey
  end

  it "should use buffnum as input when a buffer is passed" do
    expect(MockUgen.new( :audio, Buffer.new ).inputs).to eq([0])
  end

  describe "attributes" do
    before do
      @ugen = SinOsc.ar
    end

    it do
      expect(@ugen).to respond_to( :inputs )
    end

    it do
      expect(@ugen).to respond_to( :rate )
    end
  end

  describe "operations" do
    before :all do
      @op_ugen    = double( "op_ugen" )
      UnaryOpUGen = double "unary_op_ugen",  new: @op_ugen
    end

    before do
      @ugen  = SinOsc.ar
      @ugen2 = SinOsc.ar
    end

    it do # this specs all binary operations
      expect(@ugen).to respond_to( :+ )
    end

    it "should sum" do
      expect(@ugen + @ugen2).to be_a(BinaryOpUGen)
    end
  end

  describe "ugen graph in synth def" do
    before do
      Ugen.synthdef = nil
      @ugen = MockUgen.new( :audio, 1, 2 )
      @ugen2 = MockUgen.new( :audio, 1, 2 )
    end

    it "should not have synthdef" do
      expect(MockUgen.new( :audio, 1, 2 ).send( :synthdef )).to be_nil
    end

    it "should have 0 as index if not belonging to ugen" do
      expect(MockUgen.new( :audio, 1, 2 ).index).to be_zero
    end

    it "should have synthdef" do
      Ugen.synthdef = @sdef
      expect(@ugen.send( :synthdef )).to eq(@sdef)
    end

    it do
      expect(@ugen).not_to respond_to(:add_to_synthdef) # private method
    end

    it "should add to synth def on instantiation" do
      Ugen.synthdef = @sdef
      ugen = MockUgen.new( :audio, 1, 2)
      expect(ugen.send( :synthdef )).to eq(@sdef)
      expect(@sdef.children).to eq([ugen])
    end

    it "should add to synthdef and return synthdef.children size" do
      Ugen.synthdef = @sdef
      ugen, ugen2 = MockUgen.new(:audio, 1, 2), MockUgen.new(:audio, 1, 2)
      expect(@sdef.children).to eql( [ugen, ugen2] )
      expect(ugen.index).to eq(0)
      expect(ugen2.index).to eq(1)
    end

    it "should not add to synthdef" do
      Ugen.synthdef = nil
      expect(@sdef.children).not_to receive( :<< )
      expect(MockUgen.new( :audio, 1, 2 ).send( :add_to_synthdef )).to eql( nil )
    end

    it "should collect constants" do
      expect(MockUgen.new( :audio, 100, @ugen, 200 ).send( :collect_constants ).flatten.sort).to eq([1, 2, 100, 200])
    end

    it "should collect constants on arrayed inputs" do
      expect(MockUgen.new( :audio, 100, [@ugen, [200, @ugen2, 100] ] ).send( :collect_constants ).flatten.uniq.sort).to eq([1, 2, 100, 200])
    end

  end

  describe "initialization and inputs" do
    before do
      @ugen = MockUgen.new(:audio, 1, 2, 3)
    end

    it "should not accept non valid inputs" do
      expect{ @ugen = MockUgen.new(:audio, "hola") }.to raise_error( ArgumentError )
    end

    it "should require at least one argument" do
      expect { MockUgen.new }.to raise_error( ArgumentError )
    end

    it "should be a defined rate as the first argument" do
      expect { MockUgen.new( :not_a_rate, 1 ) }.to raise_error( ArgumentError )
    end

    it "should use the highest rate when passing an array" do
      expect(MockUgen.new([:audio, :control], 1).rate).to eq(:audio)
    end

    it "should be a defined rate as array" do
      expect { MockUgen.new( [:not_a_rate, :audio], 1 ) }.to raise_error( ArgumentError )
    end

    it "should accept an empty array for inputs and inputs should be an empty array" do
      expect(MockUgen.new( :audio, [] ).inputs).to eql([])
    end

    it "should instantiate" do
      expect(MockUgen.new( :audio, 1, 2 )).to be_instance_of( MockUgen )
    end

    it "should accept any number of args" do
      MockUgen.new( :audio, 1, 2 )
      MockUgen.new( :audio, 1, 2, 3, 4 )
    end

    it "should set inputs" do
      expect(@ugen.inputs).to eq([1, 2, 3])
    end

    it "should set rate" do
      expect(@ugen.rate).to eq(:audio)
    end

    it "should have empty inputs" do
      expect(MockUgen.new( :audio ).inputs).to eq([])
      expect(MockUgen.new( :audio, [] ).inputs).to eq([])
    end
  end

  describe "initialization with array as argument" do

    before :all do
      @i_1 = 100, 210
      @i_2 = 100, 220
      @i_3 = 100, 230
      @i_4 = 100, 240
    end

    it "should not care if an array was passed" do
      expect(MockUgen.new( :audio, [1, 2, 3] )).to be_instance_of(MockUgen)
    end

    it "should return an array of Ugens if an array as one arg is passed on instantiation" do
      expect(MockUgen.new( :audio, 1, [2, 3] )).to be_instance_of(DelegatorArray)
    end

    it do
      expect(MockUgen.new( :audio, 1, [2, 3], [4, 5] ).size).to eq(2)
    end

    it do
      expect(MockUgen.new( :audio, 1, [2, 3, 3], [4, 5] ).size).to eq(3)
    end

    it "should return an array of ugens" do
      ugens = MockUgen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.each do |u|
        expect(u).to be_instance_of(MockUgen)
      end
    end

    it "should return ugen" do
      ugen = MockUgen.new( :audio, [1], [2] )
      expect(ugen).to be_instance_of( MockUgen )
      expect(ugen.inputs).to eq([1, 2])
    end

    it "should return ugen" do
      ugen = MockUgen.new( :audio, [1, 2] )
      expect(ugen).to be_instance_of( MockUgen )
      expect(ugen.inputs).to eq([1, 2])
    end

    it "should make multichannel array (DelegatorArray)" do
      multichannel = MockUgen.new( :audio, 100, [210, 220] )
      expect(multichannel).to be_a(DelegatorArray)
      expect(multichannel).to eq(d(MockUgen.new(:audio, 100, 210), MockUgen.new(:audio, 100, 220)))
    end

    it "should accept DelegatorArray as inputs" do
      multichannel = MockUgen.new( :audio, 100, d(210, 220) )
      expect(multichannel).to be_a(DelegatorArray)
      expect(multichannel).to eq(d(MockUgen.new(:audio, 100, 210), MockUgen.new(:audio, 100, 220)))
    end

    it "should return an delegator array of ugens with correct inputs" do
      ugens = MockUgen.new( :audio, 100, [210, 220, 230, 240] )
      ugens.zip( [@i_1, @i_2, @i_3, @i_4] ).each do |e|
        expect(e.first.inputs).to eql( e.last )
      end
    end

    it "should match the structure of the inputs array(s)" do
      array = [ 200, [210, [220, 230] ] ]
      ugens = MockUgen.new( :audio, 100, array )
      last = lambda do |i|
        if i.instance_of?(MockUgen)
          expect(i.inputs.first).to eq(100)
          i.inputs.last
        else
          i.map{ |e| last.call(e) }
        end
      end
      expect(last.call(ugens)).to eq(array)
    end

    it "should return muladd" do
      @ugen = MockUgen.new(:audio, 100, 100)
      expect(@ugen.muladd(0.5, 0.5)).to be_a(MulAdd)
    end

    it "should return an arrayed muladd" do
      @ugen = MockUgen.new(:audio, [100, 100], 100)
      expect(@ugen.muladd(0.5, 0.5)).to be_a(DelegatorArray)
    end
  end

  describe Ugen, "encoding" do
    before do
      args = [400.0, 0.0]
      @sin = SinOsc.kr *args
      @synthdef = double "synthdef", constants: args
      allow(@sin).to receive( :index ).and_return 1 # as if was the first child of a synthdef
      allow(@sin).to receive( :synthdef ).and_return @synthdef

      @encoded = [6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 1].pack("C*")
    end

    it "should stub synthdef" do
      expect(@sin.send( :synthdef )).to eq(@synthdef)
    end

    it "should encode have 0 as special index" do
      expect(@sin.send(:special_index)).to eq(0)
    end

    it "should encode have 0 as output index" do
      expect(@sin.send(:output_index)).to eq(0)
    end

    it "should encode have [1] as output index" do
      expect(@sin.send(:channels)).to eq([1])
    end

    it "should return input_specs" do
      expect(@sin.send( :input_specs, nil )).to eq([1, 0])
    end

    it "should collect input_specs" do
      expect(@sin.send(:collect_input_specs)).to eq([[-1, 0], [-1, 1]])
    end

    it "should encode class name" do
      expect(@sin.encode[0..6]).to eq(@encoded[0..6])
    end

    it "should encode classname, rate" do
      expect(@sin.encode[0..7]).to eq(@encoded[0..7])
    end

    it "should encode cn, rt, inputs, channels, special_index" do
      expect(@sin.encode[0..13]).to eq(@encoded[0..13])
    end

    it "should encode cn, rt, in, out, si, collect_input_specs" do
      expect(@sin.encode).to eq(@encoded)
    end

    it "should equal to a similar" do
      expect(MockUgen.new(:audio, 1, 2)).to eq(MockUgen.new(:audio, 1, 2))
    end
  end
end
