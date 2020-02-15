RSpec.describe Graph do
  describe "graph with sum" do
    let(:root) { Out.ar(0, SinOsc.ar + Saw.ar) }
    let(:graph) { Graph.new(root, name: "sum") }

    it { expect(graph.nodes.map(&:name))
           .to eq %w(SinOsc Saw BinaryOpUGen Out) }
  end
end
