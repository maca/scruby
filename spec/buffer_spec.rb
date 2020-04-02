RSpec.describe Buffer do
  let(:server) do
    instance_double("Server", next_buffer_id: 10, sample_rate: 48_000)
  end

  let(:buffer) do
    described_class.new(server)
  end

  describe "instantiation" do
    it { expect(buffer.id).to be 10 }
    it { expect(buffer.sample_rate).to be 48_000 }
  end

  describe "attributes" do
    before do
      server.message_queue.send(:dispatch)
    end
  end
end
