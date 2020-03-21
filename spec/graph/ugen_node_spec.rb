RSpec.describe Graph::UgenNode do
  include Scruby
  include Scruby::Ugen

  describe "inputs" do
    include_context "node with graph"

    let(:constants) { [ 440, -1 ] }
    let(:control_names) { %i(k_1 k_2) }
    let(:ugens) { [ Ugen::SinOsc.ar, Ugen::SinOsc.kr ] }
    let(:ugen) do
      instance_double("Ugen::Base", input_values: inputs)
    end

    let(:controls) do
      [ Graph::ControlName.new(1, :control),
        Graph::ControlName.new(2, :control)
      ]
    end

    subject(:node) { described_class.build(graph, ugen) }

    before do
      allow(graph).to receive(:control_name)
                        .with(:k_1) { controls.first }

      allow(graph).to receive(:control_name)
                        .with(:k_2) { controls.last }

      allow(graph).to receive(:add_control)
                        .with(controls.first) { controls.first}

      allow(graph).to receive(:add_control)
                        .with(controls.last) { controls.last}
    end

    let(:inputs) do
      all = [ constants.dup, control_names.dup, ugens.dup ]

      [].tap do |collection|
        while all.any?(&:any?)
          elem = all.sample.shift
          collection << elem if elem
        end
      end
    end

    it "sets constants" do
      expect(node.constants)
        .to eq constants.map { |c| Graph::Constant.new(c) }
    end

    it "sets nodes" do
      expect(node.nodes)
        .to eq ugens.map { |u| Graph::UgenNode.build(graph, u) }
    end

    it "sets controls" do
      expect(node.controls).to eq controls
    end
  end

  describe ".encode" do
    context "control rate" do
      let(:ugen) { Ugen::SinOsc.kr }

      include_context "node with graph"
      include_context "node with graph constants" do
        let(:constants) do
          [ Graph::Constant.new(440),
            Graph::Constant.new(0)
          ]
        end
      end

      let(:expected) do
        [ 6, 83, 105, 110, 79, 115, 99, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0,
          0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 1
        ].pack("C*")
      end

      subject(:node) { described_class.build(graph, ugen) }

      it { expect(node).to encode_as(expected) }
    end
  end
end
