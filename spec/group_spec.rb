RSpec.describe Group do
  let(:server) { instance_double("Server") }

  subject(:group) do
    Group.new(server)
  end

  it_behaves_like "a node" do
    let(:node) { group }
  end

  it "instantiates with id" do
    expect(Group.new(server, 1).id).to be 1
  end

  describe "move node" do
    let(:node) { spy instance_double("Node") }

    describe "move to head" do
      before { group.node_to_head(node) }
      it { expect(node).to have_received(:head).with(group) }
    end

    describe "move to tail" do
      before { group.node_to_tail(node) }
      it { expect(node).to have_received(:tail).with(group) }
    end
  end


  describe "free all" do
    it_behaves_like "sent message to server" do
      subject! { group.free_all }
      let(:node) { group }
      let(:msg) { [ "/g_freeAll", group.id ] }
    end
  end


  describe "deep free" do
    it_behaves_like "sent message to server" do
      subject! { group.deep_free }
      let(:node) { group }
      let(:msg) { [ "/g_deepFree", group.id ] }
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
      it { expect(group).to be_a Group }
      it { expect(group.server).to be server }
    end

    describe "head" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.head(a_group) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 0, a_group.id ] }

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes group"
      end
    end

    describe "tail" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.tail(a_group) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 1, a_group.id ] }

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes group"
      end
    end

    describe "before" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.before(a_node) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 2, a_node.id ] }

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes group"
      end
    end

    describe "after" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.after(a_node) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 3, a_node.id ] }

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes group"
      end
    end

    describe "replace" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.replace(a_node) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 4, a_node.id ] }

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes group"
      end
    end

    describe "create" do
      it_behaves_like "sent message to server" do
        subject!(:group) { Group.create(server) }
        let(:node) { group }
        let(:msg) { [ "/g_new", group.id, 0, 1 ] }

        it { expect(node.group).to eq Group.new(server, 1) }
        it_behaves_like "initializes group"
      end
    end
  end
end
