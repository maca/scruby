RSpec.describe Ugen::UnaryOpUgen do
  describe "negate" do
    shared_examples_for "is neg unary op ugen" do
      it { expect(operation).to be_a UnaryOpUgen }
      it { expect(operation.rate).to eq :control }
      it { expect(operation.operand).to eq ugen }
      it { expect(operation.operation).to eq :neg }
    end

    describe "apply" do
      let(:ugen) { instance_double("SinOsc", rate: :control) }
      subject(:operation) { UnaryOpUgen.apply(:neg, ugen) }
      it_behaves_like "is neg unary op ugen"
    end

    describe "helper function" do
      let(:ugen) { instance_double("SinOsc", rate: :control) }
      subject(:operation) { neg(ugen) }
      it_behaves_like "is neg unary op ugen"
    end
  end
end
