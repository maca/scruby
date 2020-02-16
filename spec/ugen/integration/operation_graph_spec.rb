RSpec.describe Graph do
  describe "graph with sum" do
    let(:graph) { Graph.new(Out.ar(0, SinOsc.ar + Saw.ar), name: "sum") }

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc Saw BinaryOpUGen Out) }

    it { expect(graph.constants.map(&:value)).to eq [ 440, 0 ] }

    let(:expected) do
      [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 3, 115, 117, 109, 0, 0, 0,
        2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        4, 6, 83, 105, 110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0,
        0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 2,
        3, 83, 97, 119, 2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1, -1, -1,
        -1, 0, 0, 0, 0, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112,
        85, 71, 101, 110, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 3, 79, 117, 116, 2, 0,
        0, 0, 2, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 0, 0,
        0, 2, 0, 0, 0, 0, 0, 0 ].pack("C*")
    end

    it "should encode graph" do
      expect(graph.encode).to eq(expected)
    end
  end
end
