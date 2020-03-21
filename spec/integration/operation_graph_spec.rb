RSpec.describe Graph do
  describe "graph with float mult" do
    let(:server) { Server.new }
    let(:graph) { Graph.new(Out.ar(0, SinOsc.ar * 0.5), "mult") }

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc BinaryOpUGen Out) }

    it { expect(graph.constants.map(&:value)).to eq [ 440, 0, 0.5 ] }

    # fBinaryOpUGen\x02\x00\x00\x00\x02\x00\x00\x00\x01\x00\x02
    # fBinaryOpUGen\x02\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00

    let(:expected) do
      [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 4, 109, 117, 108, 116, 0,
        0, 0, 3, 67, -36, 0, 0, 0, 0, 0, 0, 63, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 3, 6, 83, 105, 110, 79, 115, 99, 2, 0, 0,
        0, 2, 0, 0, 0, 1, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1,
        -1, -1, 0, 0, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79,
        112, 85, 71, 101, 110, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 2, 0, 0,
        0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 2, 2, 3, 79, 117,
        116, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0,
        1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ].pack("C*")
    end

    it "encodes graph" do
      expect(graph).to encode_as(expected)
    end

    it "sends graph" do
      expect(graph.send_to(server)).to eq(graph)
    end
  end


  describe "graph with sum" do
    let(:server) { Server.new }
    let(:graph) { Graph.new(Out.ar(0, SinOsc.ar + Saw.ar), "sum") }

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

    it "encodes graph" do
      expect(graph).to encode_as(expected)
    end

    it "sends graph" do
      expect(graph.send_to(server)).to eq(graph)
    end
  end
end
