RSpec.describe UgenGraph do
  describe "initialize" do
    let(:root_ugen) { instance_double("Ugen::Base", input_values: []) }

    context "initialize with controls" do
      let(:control_params) do
        { k_1: 1, k_2: scalar(2), k_3: trigger(3), k_4: control(4) }
      end

      subject(:graph) do
        described_class.new(root_ugen, :basic, **control_params)
      end

      shared_examples_for "has controls" do
        it { expect(graph.controls)
               .to include(UgenGraph::ControlName.new(1, :control, :k_1)) }

        it { expect(graph.controls)
               .to include(UgenGraph::ControlName.new(2, :scalar, :k_2)) }

        it { expect(graph.controls)
               .to include(UgenGraph::ControlName.new(3, :trigger, :k_3)) }

        it { expect(graph.controls)
               .to include(UgenGraph::ControlName.new(4, :control, :k_4)) }
      end

      it_behaves_like "has controls"

      describe "build control" do
        it_behaves_like "has controls"
      end
    end

    context "no name is given" do
      subject(:graph) do
        described_class.new(root_ugen)
      end

      let(:regexp) do
        /[^-]{8}\-[^-]{4}\-[^-]{4}\-[^-]{4}\-[^-]{12}/
      end

      it "assigns a uuid as name" do
        expect(graph.name).to match regexp
      end

      it "name is unique" do
        expect(graph.name).not_to eq described_class.new(root_ugen).name
      end
    end
  end


  describe "building a graph" do
    context "with two ugens" do
      let(:sin_osc) { Ugen::SinOsc.ar }
      let(:ugen) { Ugen::Out.ar(1, sin_osc) }

      let(:expected) do
        [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 5, 98, 97, 115, 105, 99,
          0, 0, 0, 3, 67, -36, 0, 0, 0, 0, 0, 0, 63, -128, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99,
          2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0,
          -1, -1, -1, -1, 0, 0, 0, 1, 2, 3, 79, 117, 116, 2, 0, 0, 0,
          2, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 2, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0 ].pack("C*")
      end

      subject(:graph) { described_class.new(ugen, :basic) }

      it "should encode graph" do
        expect(graph).to encode_as(expected)
      end
    end

    context "with two ugens and controls" do
      let(:sin_osc) { Ugen::SinOsc.ar(:rate) }
      let(:ugen) { Ugen::Out.ar(:buf, sin_osc) }

      let(:expected) do
        [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 5, 98, 97, 115, 105, 99,
          0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 63, -128, 0, 0, 67, 92,
          0, 0, 0, 0, 0, 2, 3, 98, 117, 102, 0, 0, 0, 0, 4, 114, 97,
          116, 101, 0, 0, 0, 1, 0, 0, 0, 3, 7, 67, 111, 110, 116, 114,
          111, 108, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 6, 83, 105,
          110, 79, 115, 99, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 1, -1, -1, -1, -1, 0, 0, 0, 0, 2, 3, 79, 117,
          116, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ].pack("C*")
      end

      subject(:graph) do
        described_class.new(ugen, :basic, buf: 1, rate: 220)
      end

      it "should encode graph" do
        expect(graph).to encode_as(expected)
      end
    end

    it "plays"
  end

  describe "send to server" do
    let(:ugen) do
      instance_double("Ugen::Base", input_values: [], name: "SinOsc")
    end

    let(:server) { spy instance_double("Server") }
    subject(:graph) { described_class.new(ugen) }

    before { graph.send_to(server) }

    it { expect(server).to have_received(:send_graph).with(graph, nil) }
  end

  describe "equality" do
    let(:graph_a) do
      UgenGraph.new(Out.ar(0, SinOsc.ar(400) * 5), :simple)
    end

    let(:graph_b) do
      UgenGraph.new(Out.ar(0, SinOsc.ar(400) * 5.0), :simple)
    end

    let(:graph_c) do
      UgenGraph.new(Out.ar(0, SinOsc.ar(400) * 4.9), :simple)
    end

    it { expect(graph_a).to eq graph_b }
    it { expect(graph_a).not_to eq graph_c }
  end

  describe "add extra node to graph" do
    let(:expected) do
      [ 83, 67, 103, 102, 0, 0, 0, 2, 0, 1, 5, 117, 110, 105, 111,
        110, 0, 0, 0, 3, 67, -36, 0, 0, 0, 0, 0, 0, 63, -128, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 83, 105, 110, 79, 115, 99,
        2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0,
        -1, -1, -1, -1, 0, 0, 0, 1, 2, 3, 79, 117, 116, 2, 0, 0, 0, 2,
        0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 3, 83, 97, 119, 2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1,
        -1, -1, -1, 0, 0, 0, 0, 2, 3, 79, 117, 116, 2, 0, 0, 0, 2, 0,
        0, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0,
        0, 0, 0, 0 ].pack("C*")
    end

    subject(:graph) do
      described_class.new(Out.ar(0, SinOsc.ar), :union)
        .add(Out.ar(1, Saw.ar))
    end

    it "should encode graph" do
      expect(graph).to encode_as(expected)
    end
  end
end
