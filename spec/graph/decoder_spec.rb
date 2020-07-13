RSpec.describe Scruby::Graph::Decoder do
  context "groups and synths" do
    # NODE TREE Group 0
    #    1 group
    #       1018 group
    #          1020 sin
    #            freq: 300 amp: 0
    #          1019 sin
    #            freq: 300 amp: 0
    #       1015 group
    #          1017 sin
    #            freq: 300 amp: 0
    #          1016 sin
    #            freq: 300 amp: 0
    let(:msg) do
      [ 1,
        0, 1,
          1, 2,
            1018, 2,
              1020, -1, "sin", 2, "freq", 300, "amp", 0,
              1019, -1, "sin", 2, "freq", 300, "amp", 0,
            1015, 2,
              1017, -1, "sin", 2, "freq", 300, "amp", 0,
              1016, -1, "sin", 2, "freq", 300, "amp", 0
      ]
    end


    subject(:nodes) { described_class.decode(msg) }


    shared_examples_for "is node" do |id|
      it { expect(node.id).to be id }
      it { expect(node.graph).to be nodes }
      it { expect(node.parent).to be parent }
    end


    it_behaves_like "is node", 0 do
      let(:parent) { nil }
      subject(:node) { nodes.first }
    end

    it_behaves_like "is node", 1 do
      let(:parent) { nodes.first }
      subject(:node) { nodes[1] }
    end

    it_behaves_like "is node", 1018 do
      let(:parent) { nodes[1] }
      subject(:node) { nodes[1018] }
    end

    it_behaves_like "is node", 1020 do
      let(:parent) { nodes[1018] }
      subject(:node) { nodes[1020] }

      it { expect(node.params).to eq(freq: 300, amp: 0) }
    end

    it_behaves_like "is node", 1019 do
      let(:parent) { nodes[1018] }
      subject(:node) { nodes[1019] }

      it { expect(node.params).to eq(freq: 300, amp: 0) }
    end

    it_behaves_like "is node", 1015 do
      let(:parent) { nodes[1] }
      subject(:node) { nodes[1015] }
    end

    it_behaves_like "is node", 1017 do
      let(:parent) { nodes[1015] }
      let(:node) { nodes[1017] }

      it { expect(node.params).to eq(freq: 300, amp: 0) }
    end

    it_behaves_like "is node", 1016 do
      let(:parent) { nodes[1015] }
      let(:node) { nodes[1016] }

      it { expect(node.params).to eq(freq: 300, amp: 0) }
    end
  end
end
