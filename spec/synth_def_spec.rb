RSpec.describe Scruby::SynthDef do
  describe "building a synth def" do
    context "synth def with no controls" do
      subject(:synth_def) do
        SynthDef.new(:simple) do
          Out.ar(0, SinOsc.ar(400) * 0.5)
        end
      end

      let(:graph) do
        Graph.new(Out.ar(0, SinOsc.ar(400) * 0.5), :simple)
      end

      it { expect(synth_def.graph).to eq graph }
    end

    context "synth def with controls" do
      subject(:synth_def) do
        SynthDef.new(:simple) do |freq, amp = 0.5, phase|
          Out.ar(0, SinOsc.ar(freq, phase) * amp)
        end
      end

      let(:graph) do
        Graph.new(
          Out.ar(0, SinOsc.ar(:freq, :phase) * :amp), :simple,
          freq: nil, amp: 0.5, phase: nil
        )
      end

      it { expect(synth_def.graph).to eq graph }
    end

    context "synth def with scalar rate control" do
      subject(:synth_def) do
        SynthDef.new(:simple) do |freq, amp = scalar(0.5), phase|
          Out.ar(0, SinOsc.ar(freq, phase) * amp)
        end
      end

      let(:graph) do
        Graph.new(
          Out.ar(0, SinOsc.ar(:freq, :phase) * :amp), :simple,
          freq: nil, amp: scalar(0.5), phase: nil
        )
      end

      it { expect(synth_def.graph).to eq graph }
    end

    context "block does not return a ugen" do
      subject(:synth_def) do
        SynthDef.new(:simple) { }
      end

      it { expect{ synth_def }.to raise_exception(TypeError) }
    end
  end
end
