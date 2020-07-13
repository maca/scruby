RSpec.describe Scruby::Graph::Node do
  subject(:node) do
    described_class.new(:node_one, a: 1)
  end

  describe "graph" do
    let(:graph) { instance_double("Graph") }
    let(:children) { instance_double("Array") }

    before do
      node.graph = graph
      allow(graph).to receive(:children_for).with(node) { children }
    end

    it { expect(node.children).to eq children }
  end
end
