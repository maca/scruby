RSpec.describe Ugen::BinaryOpUgen do
  describe "build" do
    describe "rate" do
      let(:inputs) do
        [ instance_double("SinOsc", rate: :control),
          instance_double("SinOsc", rate: :audio) ]
      end

      it { expect(add(*inputs).rate).to eq :audio }
      it { expect(add(*inputs.reverse).rate).to eq :audio }
    end

    describe "with integer" do
      shared_examples_for "is add binary op ugen" do
        it { expect(operation).to be_a BinaryOpUgen }
        it { expect(operation.rate).to eq :control }
        it { expect(operation.left).to eq ugen }
        it { expect(operation.right).to eq 2 }
        it { expect(operation.operation).to eq :add }
      end

      describe "apply" do
        let(:ugen) { instance_double("SinOsc", rate: :control) }
        subject(:operation) { BinaryOpUgen.apply(:add, ugen, 2) }

        it_behaves_like "is add binary op ugen"
      end

      describe "helper function" do
        let(:ugen) { instance_double("SinOsc", rate: :control) }
        subject(:operation) { add(ugen, 2) }

        it_behaves_like "is add binary op ugen"
      end
    end

    describe "optimize to mul add" do
      context "operation is add" do
        let(:ugen) { instance_double("SinOsc", rate: :control) }

        context "left is mul" do
          subject(:operation) { add(mul(ugen, 2), 1) }

          it { expect(operation)
                 .to eq MulAdd.new(ugen, 2, 1, rate: :control) }
        end

        context "right is mul" do
          subject(:operation) { add(1, mul(ugen, 2)) }

          it { expect(operation)
                 .to eq MulAdd.new(ugen, 2, 1, rate: :control) }
        end
      end
    end
  end


  describe "optimize to mul add" do
    let(:p) { double("PinkNoise", rate: :audio) }
    let(:b) { double("BrownNoise", rate: :audio) }
    let(:w) { double("WhiteNoise", rate: :audio) }

    context "left is mul" do
      it { expect(add(mul(p, b), w)).to eq MulAdd.new(p, b, w) }
    end

    context "right is mul" do
      it { expect(add(w, mul(p, b))).to eq MulAdd.new(p, b, w) }
    end

    context "input is multichannel" do
      it { expect(add([ w ] * 3, mul(p, b)))
             .to eq MultiChannel.new([ MulAdd.new(p, b, w) ] * 3)  }
    end

    context "other input is array" do
      it { expect(add(w, [ mul(p, b) ] * 3))
             .to eq MultiChannel.new([ MulAdd.new(p, b, w) ] * 3)  }
    end

    context "input are arrays of different size" do
      it { expect(add([ w ] * 2, [ mul(p, b) ] * 3))
             .to eq MultiChannel.new([ MulAdd.new(p, b, w) ] * 3)  }
    end

    context "other input is multichannel" do
      it { expect(add(w, MultiChannel.new([ mul(p, b) ] * 3)))
             .to eq MultiChannel.new([ MulAdd.new(p, b, w) ] * 3)  }
    end

    context "input are multichannel of different size" do
      it { expect(
             add(MultiChannel.new([ w ] * 2),
                 MultiChannel.new([ mul(p, b) ] * 3))
           ).to eq MultiChannel.new([ MulAdd.new(p, b, w) ] * 3)  }
    end
  end
end
