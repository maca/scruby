RSpec.describe Ugen::Graph::Node do
  include Scruby
  include Scruby::Ugen

  shared_context "with graph" do
    let(:graph) { instance_double("Scruby::Ugen::Graph") }

    before do
      allow(graph).to receive(:add)
      allow(graph).to receive(:add_constant)
    end
  end

  shared_context "with graph constants" do
    before do
      allow(node).to receive(:constants) { constants }
    end
  end

  describe "inputs" do
    include_context "with graph"

    let(:constants) { [ 440, -1 ] }
    let(:ugens) { [ Ugen::SinOsc.ar, Ugen::SinOsc.kr ] }

    let(:inputs) do
      all = [ constants.dup, ugens.dup ]

      [].tap do |collection|
        while all.any?(&:any?)
          elem = all.sample.shift
          collection << elem if elem
        end
      end
    end

    let(:root_ugen) do
      instance_double("Ugen::Base", input_values: inputs)
    end

    subject(:node) { described_class.new(root_ugen, graph) }

    it "sets constants" do
      expect(node.constants)
        .to eq constants.map { |c| Ugen::Graph::Constant.new(c, graph) }
    end

    it "sets nodes" do
      expect(node.nodes)
        .to eq ugens.map { |u| Ugen::Graph::Node.new(u, graph) }
    end
  end

  describe ".encode" do
    context "control rate" do
      let(:root_ugen) { Ugen::SinOsc.kr }

      include_context "with graph"
      include_context "with graph constants" do
        let(:constants) do
          [ instance_double("Constant", input_specs: [ -1, 0 ]),
            instance_double("Constant", input_specs: [ -1, 1 ]) ]
        end
      end

      let(:expected) do
        [ 6, 83, 105, 110, 79, 115, 99, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0,
          0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 1
        ].pack("C*")
      end

      subject(:node) { described_class.new(root_ugen, graph) }

      it { expect(node.encode).to eq(expected) }
    end
  end
end
