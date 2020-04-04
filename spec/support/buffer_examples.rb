RSpec.shared_context "query buffer info" do
  let!(:info_response) do
    Concurrent::Promises.fulfilled_future(info_msg)
  end

  let!(:info_msg) do
    instance_double("OSC::Message", address: "/b_info", args: response)
  end

  before do
    allow(server).to receive(:receive).with("/b_info") { |&block|
      next info_response if block.call(info_msg)
    }
  end
end


RSpec.shared_context "sends allocation message" do
  let!(:action) { message.first }

  let!(:done_response) do
    Concurrent::Promises.fulfilled_future(done_msg)
  end

  let!(:done_msg) do
    instance_double("OSC::Message",
                    to_a: [ "/done", action, buffer_id ])
  end

  before do
    allow(server).to receive(:receive).with(no_args) { |&block|
      next done_response if block.call(done_msg)
    }
  end
end
