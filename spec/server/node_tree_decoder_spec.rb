RSpec.describe Scruby::Server::NodeTreeDecoder do
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
    subject(:root) { described_class.decode(server, msg) }

    shared_examples_for "has synth node" do |id|
      it { expect(synth.id).to be id }
      it { expect(synth).to be_a Synth }
      it { expect(synth.group).to be group }
      it { expect(synth.server).to be server }
      it { expect(synth.params).to eq(freq: 300, amp: 0) }
    end

    shared_examples_for "is group node" do |id|
      it { expect(group.id).to be id }
      it { expect(group).to be_a Group }
      it { expect(group.server).to be server }
      it { expect(group.group).to be parent }
    end


    it_behaves_like "is group node", 0 do
      let(:parent) { nil }
      subject(:group) { root }
      it { expect(group.children.size).to be 1 }
    end


    it_behaves_like "is group node", 1 do
      let(:parent) { root }
      subject(:group) { root.children.first }
      it { expect(group.children.size).to be 2 }
    end


    it_behaves_like "is group node", 1018 do
      let(:parent) { root.children.first }
      subject(:group) { parent.children.first }

      it { expect(group.children.size).to be 2 }

      it_behaves_like "has synth node", 1020 do
        let(:synth) { group.children.first }
      end

      it_behaves_like "has synth node", 1019 do
        let(:synth) { group.children.last }
      end
    end

  
    it_behaves_like "is group node", 1015 do
      let(:parent) { root.children.first }
      subject(:group) { parent.children.last }

      it { expect(group.children.size).to be 2 }

      it_behaves_like "has synth node", 1017 do
        let(:synth) { group.children.first }
      end

      it_behaves_like "has synth node", 1016 do
        let(:synth) { group.children.last }
      end
    end
  end
end
