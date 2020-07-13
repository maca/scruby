RSpec.shared_context "node with graph" do
  let(:graph) { instance_double("Scruby::UgenGraph") }

  before do
    allow(graph).to receive(:add)
    allow(graph).to receive(:add_constant)
  end
end

RSpec.shared_context "node with graph constants" do
  before do
    allow(graph).to receive(:constants) { constants }
  end
end
