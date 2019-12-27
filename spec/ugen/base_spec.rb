RSpec.describe Ugen::Base do
  include Scruby

  shared_examples_for "instance is copied" do
    it { expect(copy.object_id).not_to eq instance.object_id }
  end

  shared_examples_for "doesn't allow rate" do |_rate|
    it { expect { subject }.to raise_exception(ArgumentError) }
  end


  describe "#rates" do
    context "allowed rate is audio" do
      subject(:subclass) { Class.new(Ugen::Base) { rates :audio } }

      it { expect(subclass.rates).to eq %i(audio) }

      describe "initializes with #ar" do
        let(:instance) { subclass.ar }
        it { expect(instance.rate).to eq :audio }
      end

      it_behaves_like "doesn't allow rate", :control do
        subject { subclass.kr }
      end

      it_behaves_like "doesn't allow rate", :scalar do
        subject { subclass.ir }
      end

      it_behaves_like "doesn't allow rate", :demand do
        subject { subclass.new(rate: :demand) }
      end
    end

    context "allowed rates are audio and control" do
      subject(:subclass) do
        Class.new(Ugen::Base) do
          rates :control, :audio, :scalar, :demand
        end
      end

      it { expect(subclass.rates)
             .to eq %i(control audio scalar demand) }

      describe "initializes with #ar" do
        let(:instance) { subclass.ar }
        it { expect(instance.rate).to eq :audio }
      end

      describe "initializes with #kr" do
        let(:instance) { subclass.kr }
        it { expect(instance.rate).to eq :control }
      end

      describe "initializes with #ir" do
        let(:instance) { subclass.ir }
        it { expect(instance.rate).to eq :scalar }
      end

      describe "initializes with #new and demand" do
        let(:instance) { subclass.new(rate: :demand) }
        it { expect(instance.rate).to eq :demand }
      end
    end
  end


  describe "#input" do
    let(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio
        inputs freq: 440, phase: 0
      end
    end

    shared_examples_for "defines setter methods" do
      context "change freq" do
        let(:copy) { instance.freq(220) }
        it { expect(copy.freq).to eq 220 }
        it_behaves_like "instance is copied"
      end

      context "change phase" do
        let(:copy) { instance.phase(0.5) }
        it { expect(copy.phase).to eq 0.5 }
        it_behaves_like "instance is copied"
      end

      context "changes both freq and phase" do
        let(:copy) { instance.freq(220).phase(0.5) }
        it { expect(copy.freq).to eq 220 }
        it { expect(copy.phase).to be 0.5 }
        it_behaves_like "instance is copied"
      end
    end

    context "initialize with defaults" do
      subject(:instance) { subclass.new(rate: :audio) }

      describe "defines getter methods" do
        it { expect(instance.freq).to be 440 }
        it { expect(instance.phase).to be 0 }
      end

      it_behaves_like "defines setter methods"
    end

    context "initialize with named params" do
      subject(:instance) do
        subclass.new(rate: :audio, phase: 1, freq: 880)
      end

      describe "defines getter methods" do
        it { expect(instance.freq).to be 880 }
        it { expect(instance.phase).to be 1 }
      end

      it_behaves_like "defines setter methods"
    end
  end


  describe ".rate" do
    subject(:subclass) do
      Class.new(Ugen::Base) { rates :audio, :control }
    end

    let(:instance) { subclass.ar }

    describe "change rate" do
      let(:copy) { instance.rate(:control) }
      it { expect(copy.rate).to be :control }
      it_behaves_like "instance is copied"
    end

    describe "change to invalid rate" do
      subject { instance.rate(:demand) }
      it_behaves_like "doesn't allow rate"
    end
  end


  describe ".name" do
    subject(:subclass) do
      Class.new(Ugen::Base) { rates :audio, :control }
    end

    let(:instance) { subclass.ar }

    before do
      allow(subclass).to receive(:name) { "Scruby::Ugen::SinOsc"}
    end

    it { expect(instance.name).to eq "SinOsc"}
  end


  describe "equality" do
    subject(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio, :control
        inputs freq: 440, phase: 0
      end
    end

    let(:instance) { subclass.ar }
    it { expect(instance).to eq instance.rate(:audio) }
    it { expect(instance).not_to eq instance.rate(:control) }
    it { expect(instance).to eq instance.freq(440) }
    it { expect(instance).not_to eq instance.freq(220) }
  end
end



# RSpec.describe Ugen do
#   include Scruby
#   include Ugens


#   it "should use buffnum as input when a buffer is passed" do
#     expect(GenUgen.new(:audio, Buffer.new).inputs).to eq([0])
#   end



#   describe "operations" do
#     before :all do
#       @op_ugen    = double("op_ugen")
#       UnaryOpUGen = double "unary_op_ugen",  new: @op_ugen
#     end

#     before do
#       @ugen  = audio_rate_ugen
#       @ugen2 = audio_rate_ugen
#     end

#     it do # this specs all binary operations
#       expect(@ugen).to respond_to(:+)
#     end

#     it "should sum" do
#       expect(@ugen + @ugen2).to be_a(BinaryOpUGen)
#     end
#   end

#   describe "ugen graph in synth def" do
#     before do
#       Ugen.synthdef = nil
#       @ugen = GenUgen.new(:audio, 1, 2)
#       @ugen2 = GenUgen.new(:audio, 1, 2)
#     end

#     it "should not have synthdef" do
#       expect(GenUgen.new(:audio, 1, 2).send(:synthdef)).to be_nil
#     end

#     it "should have 0 as index if not belonging to ugen" do
#       expect(GenUgen.new(:audio, 1, 2).index).to be_zero
#     end


#     it "should collect constants" do
#       expect(GenUgen.new(:audio, 100, @ugen, 200).send(:collect_constants).flatten.sort).to eq([1, 2, 100, 200])
#     end

#     it "should collect constants on arrayed inputs" do
#       expect(GenUgen.new(:audio, 100, [@ugen, [200, @ugen2, 100]]).send(:collect_constants).flatten.uniq.sort).to eq([1, 2, 100, 200])
#     end

#   end

#   describe "initialization and inputs" do
#     before do
#       @ugen = GenUgen.new(:audio, 1, 2, 3)
#     end


#   describe "initialization with array as argument" do

#     before :all do
#       @i_1 = 100, 210
#       @i_2 = 100, 220
#       @i_3 = 100, 230
#       @i_4 = 100, 240
#     end

#     it "should not care if an array was passed" do
#       expect(GenUgen.new(:audio, [1, 2, 3])).to be_instance_of(GenUgen)
#     end

#     it "should return an array of Ugens if an array as one arg is passed on instantiation" do
#       expect(GenUgen.new(:audio, 1, [2, 3])).to be_instance_of(DelegatorArray)
#     end

#     it do
#       expect(GenUgen.new(:audio, 1, [2, 3], [4, 5]).size).to eq(2)
#     end

#     it do
#       expect(GenUgen.new(:audio, 1, [2, 3, 3], [4, 5]).size).to eq(3)
#     end

#     it "should return an array of ugens" do
#       ugens = GenUgen.new(:audio, 100, [210, 220, 230, 240])
#       ugens.each do |u|
#         expect(u).to be_instance_of(GenUgen)
#       end
#     end

#     it "should return ugen" do
#       ugen = GenUgen.new(:audio, [1], [2])
#       expect(ugen).to be_instance_of(GenUgen)
#       expect(ugen.inputs).to eq([1, 2])
#     end

#     it "should return ugen" do
#       ugen = GenUgen.new(:audio, [1, 2])
#       expect(ugen).to be_instance_of(GenUgen)
#       expect(ugen.inputs).to eq([1, 2])
#     end

#     it "should make multichannel array (DelegatorArray)" do
#       multichannel = GenUgen.new(:audio, 100, [210, 220])
#       expect(multichannel).to be_a(DelegatorArray)
#       expect(multichannel).to eq(d(GenUgen.new(:audio, 100, 210), GenUgen.new(:audio, 100, 220)))
#     end

#     it "should accept DelegatorArray as inputs" do
#       multichannel = GenUgen.new(:audio, 100, d(210, 220))
#       expect(multichannel).to be_a(DelegatorArray)
#       expect(multichannel).to eq(d(GenUgen.new(:audio, 100, 210), GenUgen.new(:audio, 100, 220)))
#     end

#     it "should return an delegator array of ugens with correct inputs" do
#       ugens = GenUgen.new(:audio, 100, [210, 220, 230, 240])
#       ugens.zip([@i_1, @i_2, @i_3, @i_4]).each do |e|
#         expect(e.first.inputs).to eql(e.last)
#       end
#     end

#     it "should match the structure of the inputs array(s)" do
#       array = [200, [210, [220, 230]]]
#       ugens = GenUgen.new(:audio, 100, array)
#       last = lambda do |i|
#         if i.instance_of?(GenUgen)
#           expect(i.inputs.first).to eq(100)
#           i.inputs.last
#         else
#           i.map{ |e| last.call(e) }
#         end
#       end
#       expect(last.call(ugens)).to eq(array)
#     end

#     it "should return muladd" do
#       @ugen = GenUgen.new(:audio, 100, 100)
#       expect(@ugen.muladd(0.5, 0.5)).to be_a(MulAdd)
#     end

#     it "should return an arrayed muladd" do
#       @ugen = GenUgen.new(:audio, [100, 100], 100)
#       expect(@ugen.muladd(0.5, 0.5)).to be_a(DelegatorArray)
#     end
#   end
# end
