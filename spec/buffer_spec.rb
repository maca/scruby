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


  shared_examples_for "sets attributes" do
    it { expect(alloc.frames).to be 20_000 }
    it { expect(alloc.channel_count).to be 2 }
    it { expect(alloc.sample_rate).to be 48_000 }
    it { expect(alloc.duration).to be(20_000 / 48_000) }
    it { expect(server)
           .to have_received(:send_msg).with("/b_query", 10) }
  end



  describe "alloc" do
    let(:buffer_id) { 10 }
    let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }
    let(:message) { [ "/b_alloc", 10, 20_000, 2 ] }

    include_context "sends allocation message"
    include_context "query buffer info"

    shared_examples_for "performs alloc" do
      it_behaves_like "sets attributes"
      it { expect(alloc.id).to be 10 }
      it { expect(server).to have_received(:send_msg).with(*message) }
    end

    context "sync" do
      subject!(:alloc) { buffer.alloc(20_000, 2) }
      it_behaves_like "performs alloc"
    end

    context "block given" do
      it { expect { |b| buffer.alloc(20_000, 2, &b) }
             .to yield_with_args(buffer) }
    end

    context "async" do
      subject!(:alloc) { buffer.alloc_async(20_000, 2).value! }
      it_behaves_like "performs alloc"
    end
  end


  describe "alloc read" do
    let(:buffer_id) { 10 }
    let(:path) { File.expand_path("audio.aiff") }
    let(:message) { [ "/b_allocRead", 10, path, 10, -10 ] }
    let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }

    include_context "sends allocation message"
    include_context "query buffer info"

    shared_examples_for "performs alloc" do
      it_behaves_like "sets attributes"
      it { expect(alloc.id).to be 10 }
      it { expect(server).to have_received(:send_msg).with(*message) }
    end

    context "sync" do
      subject!(:alloc) { buffer.alloc_read("audio.aiff", 10, -10) }
      it_behaves_like "performs alloc"
    end

    context "block given" do
      it { expect { |b| buffer.alloc_read("audio.aiff", 10, -10, &b) }
             .to yield_with_args(buffer) }
    end

    context "async" do
      subject!(:alloc) { buffer.alloc_read_async("audio.aiff", 10, -10)
                           .value! }
      it_behaves_like "performs alloc"
    end
  end


  describe "close" do
    let(:buffer_id) { 10 }
    let(:message) { [ "/b_close", 10 ] }
    let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }

    include_context "sends allocation message"
    include_context "query buffer info"

    shared_examples_for "performs alloc" do
      it_behaves_like "sets attributes"
      it { expect(alloc.id).to be 10 }
      it { expect(server).to have_received(:send_msg).with(*message) }
    end

    context "sync" do
      subject!(:alloc) { buffer.close }
      it_behaves_like "performs alloc"
    end

    context "block given" do
      it { expect { |b| buffer.close(&b) }.to yield_with_args(buffer) }
    end

    context "async" do
      subject!(:alloc) { buffer.close_async.value! }
      it_behaves_like "performs alloc"
    end
  end


  describe "copy data" do
    let(:buffer_id) { 10 }
    let(:dest_buffer) { instance_double("Buffer", id: 11) }
    let(:message) { [ "/b_gen", 11, "copy", 1, 10, 2, 3 ] }
    let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }

    include_context "sends allocation message"
    include_context "query buffer info"

    shared_examples_for "performs alloc" do
      it_behaves_like "sets attributes"
      it { expect(alloc.id).to be 10 }
      it { expect(server).to have_received(:send_msg).with(*message) }
    end

    context "sync" do
      subject!(:alloc) { buffer.copy_data(dest_buffer, 1, 2, 3) }
      it_behaves_like "performs alloc"
    end

    context "block given" do
      it { expect { |b| buffer.copy_data(dest_buffer, &b) }
             .to yield_with_args(buffer) }
    end

    context "async" do
      subject!(:alloc) do
        buffer.copy_data_async(dest_buffer, 1, 2, 3).value!
      end

      it_behaves_like "performs alloc"
    end
  end


  describe "read" do
    let(:buffer_id) { 10 }
    let(:path) { File.expand_path("audio.aiff") }
    let(:message) { [ "/b_read", 10, path, 1, 2, 3, false ] }
    let(:response) { [ buffer_id, 20_000, 2, 48_000 ] }

    include_context "sends allocation message"
    include_context "query buffer info"

    shared_examples_for "performs alloc" do
      it_behaves_like "sets attributes"
      it { expect(alloc.id).to be 10 }
      it { expect(server).to have_received(:send_msg).with(*message) }
    end

    context "sync" do
      subject!(:alloc) { buffer.read("audio.aiff", 1, 2, 3, false) }
      it_behaves_like "performs alloc"
    end

    context "block given" do
      it { expect { |b| buffer.read("audio.aiff", &b) }
             .to yield_with_args(buffer) }
    end

    context "async" do
      subject!(:alloc) do
        buffer.read_async("audio.aiff", 1, 2, 3, false).value!
      end

      it_behaves_like "performs alloc"
    end
  end
end
