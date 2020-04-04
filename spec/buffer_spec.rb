RSpec.describe Buffer do
  let(:server) do
    instance_double("Server", next_buffer_id: 10, sample_rate: 48_000)
  end

  before { allow(server).to receive(:send_msg) { server } }

  let(:buffer) do
    described_class.new(server)
  end

  describe "instantiation" do
    it { expect(buffer.id).to be 10 }
  end

  describe "query" do
    let(:buffer_id) { 10 }

    include_context "query buffer info" do
      let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }
    end

    subject!(:query) { buffer.query }

    it { should include(id: 10) }
    it { should include(frames: 20_000) }
    it { should include(channel_count: 2) }
    it { should include(sample_rate: 48_000) }
    it { expect(server)
           .to have_received(:send_msg).with("/b_query", 10) }
  end

  describe "alloc" do
    let(:buffer_id) { 10 }

    include_context "sends allocation message" do
      let(:message) { [ "/b_alloc", 10, 20_000, 2 ] }
    end

    include_context "query buffer info" do
      let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }
    end

    subject!(:alloc) { buffer.alloc(20_000, 2) }

    it { expect(alloc.frames).to be 20_000 }
    it { expect(alloc.channel_count).to be 2 }
    it { expect(alloc.sample_rate).to be 48_000 }
    it { expect(server)
           .to have_received(:send_msg).with("/b_query", 10) }
    it { expect(server).to have_received(:send_msg).with(*message) }
  end
end
