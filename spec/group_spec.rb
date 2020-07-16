RSpec.describe Group do
  let(:server) { instance_double("Server", next_node_id: 16) }

  subject(:group) do
    Group.new(server, 16)
  end

  it_behaves_like "performs node actions" do
    let(:node) { group }
  end

  describe "move node" do
    let(:node) { spy instance_double("Node") }

    describe "move to head" do
      before { group.node_to_head(node) }
      it { expect(node).to have_received(:move_to_head).with(group) }
    end

    describe "move to tail" do
      before { group.node_to_tail(node) }
      it { expect(node).to have_received(:move_to_tail).with(group) }
    end
  end


  describe "free all" do
    it_behaves_like "sent message to server" do
      subject! { group.free_all }
      let(:node) { group }
      let(:msg) { [ "/g_freeAll", 16 ] }
    end
  end


  describe "deep free" do
    it_behaves_like "sent message to server" do
      subject! { group.deep_free }
      let(:node) { group }
      let(:msg) { [ "/g_deepFree", 16 ] }
    end
  end


  describe "initialize with position" do
    let(:a_group) do
      instance_double("Group", id: 5555, server: server)
    end

    let(:a_node) do
      instance_double("Node", id: 2222, server: server, group: a_group)
    end

    shared_examples_for "initializes group" do
      let(:node_node) { instance_double("Graph::Node") }
      let(:nodes) { instance_double("Nodes") }

      before do
        allow(nodes).to receive(:node).with(16) { node_node }
        allow(server).to receive(:nodes) { nodes }
      end

      it { expect(group).to be_a Group }
      it { expect(group.server).to be server }
      it { expect(node.node).to eq node_node }
    end

    describe "head" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Group.head(a_group) }
        let(:msg) { [ "/g_new", 16, 0, a_group.id ] }

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes group"
      end
    end

    describe "tail" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Group.tail(a_group) }
        let(:msg) { [ "/g_new", 16, 1, a_group.id ] }

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes group"
      end
    end

    describe "before" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Group.before(a_node) }
        let(:msg) { [ "/g_new", 16, 2, a_node.id ] }

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes group"
      end
    end

    describe "after" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Group.after(a_node) }
        let(:msg) { [ "/g_new", 16, 3, a_node.id ] }

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes group"
      end
    end

    describe "replace" do
      it_behaves_like "sent message to server" do
        subject!(:node) { Group.replace(a_node) }
        let(:msg) { [ "/g_new", 16, 4, a_node.id ] }

        it { expect(node.id).to be 16 }
        it_behaves_like "initializes group"
      end
    end

    describe "create" do
      before do
        allow(server).to receive(:node).with(1) do
          instance_double("Node", id: 1)
        end
      end

      it_behaves_like "sent message to server" do
        subject!(:node) { Group.create(server) }
        let(:msg) { [ "/g_new", 16, 0, 1 ] }

        it { expect(node.id).to be 16 }
      end
    end
  end
end
