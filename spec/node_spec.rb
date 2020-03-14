RSpec.describe Synth do
  let(:server) { instance_double('Server') }

  subject(:synth) do
    Synth.new(:synth, server)
  end

  it { expect(synth.name).to eq :synth }

  it_behaves_like 'a node' do
    let(:node) { synth }
  end
end
