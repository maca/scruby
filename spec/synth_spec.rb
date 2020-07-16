RSpec.describe Synth do
  let(:server) { instance_double("Server", next_node_id: 16) }

  it_behaves_like "performs node actions" do
    let(:node) { Synth.new(server) }
  end

  before do
    allow(server).to receive(:node).with(1) do
      instance_double("Node", server: server, id: 1)
    end
  end

  describe "initialize with position" do
    let(:a_group) do
      instance_double("Group", id: 5555, server: server)
    end

    let(:a_node) do
      instance_double("Node", id: 2222, server: server, group: a_group)
    end

    shared_examples_for "initializes synth" do
      let(:node_node) { instance_double("Graph::Node") }
      let(:nodes) { instance_double("Nodes") }

      before do
        allow(nodes).to receive(:node).with(16) { node_node }
        allow(server).to receive(:nodes) { nodes }
      end

      it { expect(node).to be_a Synth }
      it { expect(node.server).to be server }
      it { expect(node.node).to eq node_node }
    end

    describe "head" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.head(a_group, :test, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 0, a_group.id, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end

    describe "tail" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.tail(a_group, :test, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 1, a_group.id, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end

    describe "before" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.before(a_node, :test, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 2, a_node.id, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end

    describe "after" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.after(a_node, :test, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 3, a_node.id, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end

    describe "replace" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.replace(a_node, :test, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 4, a_node.id, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end

    describe "create" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Synth.create(:test, server, a: 1) }
        let(:msg) do
          [ "/s_new", :test, 16, 0, 1, :a, 1 ]
        end

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes synth"
      end
    end
  end
end
