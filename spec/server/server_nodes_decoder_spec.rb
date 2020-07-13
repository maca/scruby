RSpec.describe Scruby::Server::ServerNodesDecoder do
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


    let(:server) { instance_double("Server") }
    subject(:nodes) { described_class.new(server).decode(msg) }


    shared_examples_for "is synth node" do |id|
      it { expect(synth.id).to be id }
      it { expect(synth).not_to be_group }
      it { expect(synth.group).to be parent }
      it { expect(synth.server).to be server }
      it { expect(synth.params).to eq(freq: 300, amp: 0) }
    end

    shared_examples_for "is group node" do |id|
      it { expect(group.id).to be id }
      it { expect(group).to be_group }
      it { expect(group.server).to be server }
      it { expect(group.group).to be parent }
    end


    it_behaves_like "is group node", 0 do
      let(:parent) { nil }
      subject(:group) { nodes.first }
    end

    it_behaves_like "is group node", 1 do
      let(:parent) { nodes.first }
      subject(:group) { nodes[1] }
    end

    it_behaves_like "is group node", 1018 do
      let(:parent) { nodes[1] }
      subject(:group) { nodes[2] }
    end

    it_behaves_like "is synth node", 1020 do
      let(:parent) { nodes[2] }
      subject(:synth) { nodes[3] }
    end

    it_behaves_like "is synth node", 1019 do
      let(:parent) { nodes[2] }
      subject(:synth) { nodes[4] }
    end

    it_behaves_like "is group node", 1015 do
      let(:parent) { nodes[1] }
      subject(:group) { nodes[5] }
    end

    it_behaves_like "is synth node", 1017 do
      let(:parent) { nodes[5] }
      let(:synth) { nodes[6] }
    end

    it_behaves_like "is synth node", 1016 do
      let(:parent) { nodes[5] }
      let(:synth) { nodes[7] }
    end
  end
end
