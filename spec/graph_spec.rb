RSpec.describe Scruby::Graph do
  let(:zero) { instance_double("Graph::Node", id: 0, parent: nil) }
  let(:one) { instance_double("Graph::Node", id: 1,  parent: 0) }
  let(:two) { instance_double("Graph::Node", id: 2, parent: 0) }
  let(:three) { instance_double("Graph::Node", id: 3, parent: 1) }
  let(:four) { instance_double("Graph::Node", id: 4, parent: 1) }

  let(:nodes) do
    [ zero, one, two, three, four ]
  end

  before do
    nodes.each { |node| allow(node).to receive(:graph=) }
  end

  subject(:graph) { Graph.new(nodes) }

  describe "get node" do
    it { expect(graph[0]).to eq zero }
    it { expect(graph[1]).to eq one }
    it { expect(graph[2]).to eq two }
    it { expect(graph[3]).to eq three }
    it { expect(graph[4]).to eq four }
  end

  describe "children for node" do
    it { expect(graph.children_for(nil)).to eq [ zero ] }
    it { expect(graph.children_for(0)).to eq [ one, two ] }
    it { expect(graph.children_for(1)).to eq [ three, four ] }
    it { expect(graph.children_for(2)).to eq [ ] }
  end

  describe "enumerable methods" do
    it { expect(graph.to_a).to eq nodes }
    it { expect(graph.each.to_a).to eq nodes }
  end
end
