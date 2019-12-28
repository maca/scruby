RSpec.describe Ugen::Graph do
  include Scruby

  describe "building a graph" do
    context "with two ugens" do
      let(:sin_osc) { Ugen::SinOsc.ar }
      let(:ugen) { Ugen::Out.ar(1, sin_osc) }

      let(:expected) do
        %w(
        00 00 00 03  43
        dc 00 00 00  00 00 00 3f  80 00 00 00  00 00 00 00
        00 00 00 00  00 00 02 06  53 69 6e 4f  73 63 02 00
        00 00 02 00  00 00 01 00  00 ff ff ff  ff 00 00 00
        00 ff ff ff  ff 00 00 00  01 02 03 4f  75 74 02 00
        00 00 02 00  00 00 00 00  00 ff ff ff  ff 00 00 00
        02 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
        )
      end

      subject(:graph) { described_class.new(ugen) }

      let(:encoded) do
        graph.encode.unpack("C*")
          .map { |num| num.to_s(16).rjust(2, "0") }
      end

      it { expect(graph.constants.map(&:value)).to eq [ 440, 0, 1 ] }
      it { expect(graph.nodes.map(&:value)).to eq [ sin_osc, ugen ] }

      it "should encode graph" do
        expect(encoded).to eq(expected)
      end
    end
  end
end
