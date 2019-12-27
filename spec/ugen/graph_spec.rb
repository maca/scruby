RSpec.describe Ugen::Graph do
  include Scruby

  describe ".encode_ugen" do
    context "single ugen" do
      let(:sin_osc) do
        Class.new(Ugen::Base) do
          rates :control
          inputs freq: 440, phase: 0
        end.new(rate: :control)
      end

      let(:expected) do
        [ 0x06, 0x53, 0x69, 0x6e, 0x4f, 0x73, 0x63, 0x01, 0x00, 0x02,
          0x00, 0x01, 0x00, 0x00, -0x01, -0x01, 0x00, 0x00, -0x01,
          -0x01, 0x00, 0x01, 0x01 ].pack("C*")
      end

      let(:encoded_ugen) { graph.encode }

      subject(:graph) { described_class.new }

      before do
        allow(sin_osc).to receive(:name) { "SinOsc" }
        allow(graph).to receive(:constants) { [ 440, 0 ] }
      end

      it "should encode class name" do
        expect(encoded_ugen[0..6]).to eq(expected[0..6])
      end

      it "should encode classname, rate" do
        expect(encoded_ugen[0..7]).to eq(expected[0..7])
      end

      it "should encode cn, rt, inputs, channels, special index" do
        expect(encoded_ugen[0..13]).to eq(expected[0..13])
      end

      it "should encode cn, rt, ins, chans, si, input specs" do
        expect(encoded_ugen).to eq(expected)
      end
    end
  end
end
