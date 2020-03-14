RSpec.shared_examples_for "sent message to server" do
  before do
    allow(server).to receive(:send_msg).with(any_args)
  end

  it { expect(server).to have_received(:send_msg).with(*msg) }
  it { expect(subject).to eq node }
end


RSpec.shared_examples_for "sent bundle to server" do
  before do
    allow(server).to receive(:send_bundle).with(any_args)
  end

  it { expect(server).to have_received(:send_bundle).with(*bundle) }
  it { expect(subject).to eq node }
end


RSpec.shared_examples_for "a node" do
  let(:a_group) { instance_double("Group", id: 5555) }

  it { expect(node.server).to eq server }
  it { expect(node.id).to be_an Integer }

  it_behaves_like "is equatable"


  describe "free" do
    before do
      node.instance_variable_set(:@group, a_group)
    end

    it_behaves_like "sent message to server" do
      subject! { node.free }
      let(:msg) { [ "/n_free", node.id ] }
      it { expect(node.group).to be nil }
    end
  end

  describe "run" do
    it_behaves_like "sent message to server" do
      subject! { node.run }
      let(:msg) { [ "/n_run", node.id, true ] }
    end
  end

  describe "map" do
    it_behaves_like "sent bundle to server" do
      subject! do
        node.map(
          a: instance_double("Bus", rate: :audio, index: 2,
                             channels: 1),
          b: instance_double("Bus", rate: :control, index: 0,
                            channels: 2),
          c: instance_double("Bus", rate: :control, index: 1,
                            channels: 3),
          d: instance_double("Bus", rate: :audio, index: 3,
                             channels: 4),
          e: instance_double("Bus", rate: :other, index: 4,
                             channels: 1)
        )
      end

      let(:bundle) do
        [
          [ "/n_mapan", node.id, :a, 2, 1, :d, 3, 4 ],
          [ "/n_mapn", node.id, :b, 0, 2, :c, 1, 3 ]
        ]
      end
    end
  end

  describe "release" do
    context "release time is not given" do
      it_behaves_like "sent message to server" do
        subject! { node.release }
        let(:msg) { [ 15, node.id, :gate, 0 ] }
      end
    end

    context "release time is minus one" do
      it_behaves_like "sent message to server" do
        subject! { node.release(-1) }
        let(:msg) { [ 15, node.id, :gate, -1 ] }
      end
    end

    context "release time is negative" do
      it_behaves_like "sent message to server" do
        subject! { node.release(-10) }
        let(:msg) { [ 15, node.id, :gate, -1 ] }
      end
    end

    context "release time is positive" do
      it_behaves_like "sent message to server" do
        subject! { node.release(13) }
        let(:msg) { [ 15, node.id, :gate, -14 ] }
      end
    end
  end

  describe "trace" do
    it_behaves_like "sent message to server" do
      subject! { node.trace }
      let(:msg) { [ "/n_trace", node.id ] }
    end
  end

  describe "move node" do
    let(:other) { instance_double("Node", id: 2222, group: a_group) }

    describe "before" do
      it_behaves_like "sent message to server" do
        subject! { node.before(other) }
        let(:msg) { [ "/n_before", node.id, 2222 ] }

        it { expect(node.group).to eq a_group }
      end
    end

    describe "after" do
      it_behaves_like "sent message to server" do
        subject! { node.after(other) }
        let(:msg) { [ "/n_after", node.id, 2222 ] }

        it { expect(node.group).to eq a_group }
      end
    end

    describe "head" do
      it_behaves_like "sent message to server" do
        subject! { node.head(a_group) }
        let(:msg) { [ "/g_head", 5555, node.id ] }

        it { expect(node.group).to eq a_group }
      end
    end

    describe "tail" do
      it_behaves_like "sent message to server" do
        subject! { node.tail(a_group) }
        let(:msg) { [ "/g_tail", 5555, node.id ] }

        it { expect(node.group).to eq a_group }
      end
    end
  end
end
