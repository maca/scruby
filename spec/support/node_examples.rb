RSpec.shared_examples_for 'a node' do
  before do
    allow(server).to receive(:send_msg).with(any_args)
    allow(server).to receive(:send_bundle).with(any_args)
  end

  it { expect(synth.server).to eq server }
  it { expect(synth.id).to be_an Integer }

  shared_examples_for 'sent message to server' do
    it { expect(server).to have_received(:send_msg).with(*msg) }
    it { expect(subject).to eq node }
  end

  shared_examples_for 'sent bundle to server' do
    it { expect(server).to have_received(:send_bundle).with(*msg) }
    it { expect(subject).to eq node }
  end

  describe 'free' do
    subject! { node.free }

    it_behaves_like 'sent message to server' do
      let(:msg) { [ '/n_free', node.id ] }
    end
  end

  describe 'run' do
    subject! { node.run }

    it_behaves_like 'sent message to server' do
      let(:msg) { [ '/n_run', node.id, true ] }
    end
  end

  describe 'map' do
    subject! do
      node.map(
        a: instance_double('Bus', rate: :audio, index: 2, channels: 1),
        b: instance_double('Bus',
                           rate: :control, index: 0, channels: 2),
        c: instance_double('Bus',
                           rate: :control, index: 1, channels: 3),
        d: instance_double('Bus', rate: :audio, index: 3, channels: 4),
        e: instance_double('Bus', rate: :other, index: 4, channels: 1)
      )
    end

    it_behaves_like 'sent bundle to server' do
      let(:msg) do
        [
          [ '/n_mapan', node.id, :a, 2, 1, :d, 3, 4 ],
          [ '/n_mapn', node.id, :b, 0, 2, :c, 1, 3 ]
        ]
      end
    end
  end
end
