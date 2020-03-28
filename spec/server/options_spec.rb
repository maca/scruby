RSpec.describe Scruby::Server::Options do
  subject(:options) { described_class.new }

  describe "some defaults" do
    it { expect(options.address).to eq "127.0.0.1" }
    it { expect(options.port).to be 57_110 }
    it { expect(options.protocol).to be :udp }
    it { expect(options.max_logins).to be 32 }
    it { expect(options.num_input_bus_channels).to be 2 }
    it { expect(options.num_output_bus_channels).to be 2 }
  end

  describe "flags" do
    let(:flags) do
      %w(
        -B 127.0.0.1
        -u 57110
        -a 1024
        -c 16384
        -i 2
        -o 2
        -b 1024
        -n 1024
        -d 1024
        -z 64
        -m 8192
        -r 64
        -w 64
        -V 0
        -R 0
        -l 32
      ).join(" ")
    end

    it { expect(options.flags).to eq flags }
  end
end
