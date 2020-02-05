RSpec.describe Ugen::Graph do
  include Scruby

  describe "building a graph" do
    context "with two ugens" do
      let(:sin_osc) { Ugen::SinOsc.ar }
      let(:ugen) { Ugen::Out.ar(1, sin_osc) }

      let(:expected) do
        [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 5, 98, 97, 115, 105, 99,
          0, 0, 0, 3, 67, -36, 0, 0, 0, 0, 0, 0, 63, -128, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99,
          2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0,
          -1, -1, -1, -1, 0, 0, 0, 1, 2, 3, 79, 117, 116, 2, 0, 0, 0,
          2, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 2, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0 ].pack("C*")
      end

      subject(:graph) { described_class.new(ugen, name: :basic) }

      it { expect(graph.constants.map(&:value)).to eq [ 440, 0, 1 ] }
      it { expect(graph.nodes.map(&:value)).to eq [ sin_osc, ugen ] }

      it "should encode graph" do
        expect(graph.encode).to eq(expected)
      end
    end
  end
end
