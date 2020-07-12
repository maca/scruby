RSpec.describe Synth do
  let(:server) { instance_double("Server", next_node_id: 1) }

  subject(:synth) do
    Synth.new(:test, server)
  end

  it { expect(synth.name).to eq :test }

  it_behaves_like "a node" do
    let(:node) { synth }
  end

  describe "instantiation" do
    subject(:synth) do
      Synth.new(:synth, server, 1, a: 1)
    end

    it { expect(synth.id).to be 1 }
    it { expect(synth.server).to be server }
    it { expect(synth.params).to eq(a: 1) }
  end

  describe "initialize with position" do
    let(:a_group) do
      instance_double("Group", id: 5555, server: server)
    end

    let(:a_node) do
      instance_double("Node", id: 2222, server: server, group: a_group)
    end

    shared_examples_for "initializes synth" do
      it { expect(synth).to be_a Synth }
      it { expect(synth.server).to be server }
    end

    describe "head" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.head(a_group, :test, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 0, a_group.id, "a", 1 ]
        end

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes synth"
      end
    end

    describe "tail" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.tail(a_group, :test, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 1, a_group.id, "a", 1 ]
        end

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes synth"
      end
    end

    describe "before" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.before(a_node, :test, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 2, a_node.id, "a", 1 ]
        end

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes synth"
      end
    end

    describe "after" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.after(a_node, :test, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 3, a_node.id, "a", 1 ]
        end

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes synth"
      end
    end

    describe "replace" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.replace(a_node, :test, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 4, a_node.id, "a", 1 ]
        end

        it { expect(node.group).to eq a_group }
        it_behaves_like "initializes synth"
      end
    end

    describe "create" do
      it_behaves_like "sent message to server" do
        subject!(:synth) { Synth.create(:test, server, a: 1) }
        let(:node) { synth }
        let(:msg) do
          [ "/s_new", "test", synth.id, 0, 1, "a", 1 ]
        end

        it { expect(node.group).to eq Group.new(server, 1) }
        it_behaves_like "initializes synth"
      end
    end
  end
end
