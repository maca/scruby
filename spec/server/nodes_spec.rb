RSpec.describe Server::Nodes do
  let(:server) { instance_double("Server") }

  subject(:node) { described_class.new(server) }
end
