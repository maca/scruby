RSpec.describe Scruby::Server::Options do
  subject(:server_options) { described_class.new }

  describe "some defaults" do
    it { expect(server_options.num_input_bus_channels).to be 2 }
    it { expect(server_options.num_output_bus_channels).to be 2 }
  end
end
