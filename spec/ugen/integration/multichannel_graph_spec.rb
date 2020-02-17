RSpec.describe Graph do
  describe "simple graph with two channels" do
    let(:graph) do
      Graph.new(Out.ar(0, [ SinOsc.ar, Saw.ar ]), name: "multichannel")
    end

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc Saw Out) }

    it { expect(graph.constants.map(&:value)).to eq [ 440, 0 ] }

    let(:expected) do
      [
        83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 12, 109, 117, 108, 116,
        105, 99, 104, 97, 110, 110, 101, 108, 0, 0, 0, 2, 67, -36, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6, 83, 105,
        110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, -1, -1, -1,
        -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2, 3, 83, 97, 119,
        2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0,
        2, 3, 79, 117, 116, 2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, -1, -1,
        -1, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
        0, 0, 0, 0
      ].pack("C*")
    end

    it "should encode graph" do
      expect(graph.encode).to eq(expected)
    end
  end


  describe "simple ugen with array input" do
    let(:graph) do
      Graph.new(Out.ar(0, SinOsc.ar([242, 442])), name: "multichannel")
    end

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc SinOsc Out) }

    it { expect(graph.constants.map(&:value)).to eq [ 242, 0, 442 ] }

    let(:expected) do
      [
        83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 12, 109, 117, 108, 116,
        105, 99, 104, 97, 110, 110, 101, 108, 0, 0, 0, 3, 67, 114, 0,
        0, 0, 0, 0, 0, 67, -35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        3, 6, 83, 105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0,
        0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2,
        6, 83, 105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0,
        -1, -1, -1, -1, 0, 0, 0, 2, -1, -1, -1, -1, 0, 0, 0, 1, 2, 3,
        79, 117, 116, 2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1,
        0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
      ].pack("C*")
    end

    it "should encode graph" do
      expect(graph.encode).to eq(expected)
    end
  end

  describe "simple nested multichannel" do
    let(:graph) do
      Graph.new(
        Out.ar(0, SinOsc.ar(SinOsc.ar([242, 442]))),
        name: "multichannel"
      )
    end

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc SinOsc SinOsc SinOsc Out) }

    it { expect(graph.constants.map(&:value)).to eq [ 242, 0, 442 ] }

    let(:expected) do
      [
        83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 12, 109, 117, 108, 116,
        105, 99, 104, 97, 110, 110, 101, 108, 0, 0, 0, 3, 67, 114, 0,
        0, 0, 0, 0, 0, 67, -35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 6, 83, 105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0,
        0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2,
        6, 83, 105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2, 6, 83,
        105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, -1,
        -1, -1, -1, 0, 0, 0, 2, -1, -1, -1, -1, 0, 0, 0, 1, 2, 6, 83,
        105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0,
        0, 2, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2, 3, 79, 117,
        116, 2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0,
        1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0
      ].pack("C*")
    end

    it "should encode graph" do
      expect(graph.encode).to eq(expected)
    end
  end
end
