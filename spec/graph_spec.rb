RSpec.describe Scruby::Graph do
  let(:zero) { instance_double("Graph::Node", id: 0, parent: nil) }
  let(:one) { instance_double("Graph::Node", id: 1,  parent: zero) }
  let(:two) { instance_double("Graph::Node", id: 2, parent: zero) }
  let(:three) { instance_double("Graph::Node", id: 3, parent: one) }
  let(:four) { instance_double("Graph::Node", id: 4, parent: one) }

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
    it { expect(graph.children_for(zero)).to eq [ one, two ] }
    it { expect(graph.children_for(one)).to eq [ three, four ] }
    it { expect(graph.children_for(two)).to eq [ ] }
  end

  describe "add node" do
    let(:five) { instance_double("Graph::Node", id: 5, parent: one) }

    before do
      expect(five).to receive(:graph=).with(graph)
      graph.add(five)
    end

    it { expect(graph[5]).to eq five }
    it { expect(graph.children_for(one)).to eq [ three, four, five ] }
  end

  describe "enumerable methods" do
    it { expect(graph.to_a).to eq nodes }
    it { expect(graph.each.to_a).to eq nodes }
  end
end
