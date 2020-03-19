RSpec.shared_context "node with graph" do
  let(:graph) { instance_double("Scruby::Graph") }

  before do
    allow(graph).to receive(:add_node)
    allow(graph).to receive(:add_constant)
  end
end

RSpec.shared_context "node with graph constants" do
  before do
    allow(graph).to receive(:constants) { constants }
  end
end
