RSpec.describe Server do
  it "should have a lot more tests"


  describe "sends graph" do
    let(:graph) { instance_double("Graph", encode: "encoded-graph") }
    let(:blob) { OSC::Blob.new("encoded-graph") }
    let(:server) { Server.new }

    context "no completion message is provided" do
      before do
        allow(server).to receive(:send_bundle)
        server.send_graph(graph)
      end

      let(:message) { OSC::Message.new("/d_recv", blob, 0) }

      it { expect(server).to have_received(:send_bundle).with(message) }
    end
  end
end
