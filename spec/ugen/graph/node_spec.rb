RSpec.describe Ugen::Graph::Node do
  include Scruby

  describe ".encode" do
    context "control rate" do
      let(:sin_osc) { Ugen::SinOsc.kr }
      let(:graph) { instance_double("Scruby::Ugen::Graph") }

      let(:expected) do
        [ 6, 83, 105, 110, 79, 115, 99, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0,
          0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 1
        ].pack("C*")
      end

      subject(:node) { described_class.new(sin_osc, graph) }

      before do
        allow(graph).to receive(:add_constant)
        allow(graph).to receive(:add)

        allow(node).to receive(:constants) do
          [ instance_double("Constant", input_specs: [ -1, 0 ]),
            instance_double("Constant", input_specs: [ -1, 1 ]) ]
        end
      end

      it { expect(node.encode).to eq(expected) }
    end
  end
end
