RSpec.describe Ugen::Base do
  include Scruby

  shared_examples_for "instance is copied" do
    it { expect(copy.object_id).not_to eq instance.object_id }
  end

  shared_examples_for "doesn't allow rate" do |_rate|
    it { expect { subject }.to raise_exception(ArgumentError) }
  end


  describe "#rates" do
    context "allowed rate is audio" do
      subject(:subclass) { Class.new(Ugen::Base) { rates :audio } }

      it { expect(subclass.rates).to eq %i(audio) }

      describe "initializes with #ar" do
        let(:instance) { subclass.ar }
        it { expect(instance.rate).to eq :audio }
      end

      it_behaves_like "doesn't allow rate", :control do
        subject { subclass.kr }
      end

      it_behaves_like "doesn't allow rate", :scalar do
        subject { subclass.ir }
      end

      it_behaves_like "doesn't allow rate", :demand do
        subject { subclass.new(rate: :demand) }
      end
    end

    context "allowed rates are audio and control" do
      subject(:subclass) do
        Class.new(Ugen::Base) do
          rates :control, :audio, :scalar, :demand
        end
      end

      it { expect(subclass.rates)
             .to eq %i(control audio scalar demand) }

      describe "initializes with #ar" do
        let(:instance) { subclass.ar }
        it { expect(instance.rate).to eq :audio }
      end

      describe "initializes with #kr" do
        let(:instance) { subclass.kr }
        it { expect(instance.rate).to eq :control }
      end

      describe "initializes with #ir" do
        let(:instance) { subclass.ir }
        it { expect(instance.rate).to eq :scalar }
      end

      describe "initializes with #new and demand" do
        let(:instance) { subclass.new(rate: :demand) }
        it { expect(instance.rate).to eq :demand }
      end
    end
  end


  describe "#initialize" do
    let(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio
        attributes foo: :bar
        inputs freq: 440, phase: 0
      end
    end

    describe "defines setter methods" do
      subject(:instance) { subclass.new(rate: :audio) }

      context "change freq" do
        let(:copy) { instance.freq(220) }
        it { expect(copy.freq).to eq 220 }
        it_behaves_like "instance is copied"
      end

      context "change phase" do
        let(:copy) { instance.phase(0.5) }
        it { expect(copy.phase).to eq 0.5 }
        it_behaves_like "instance is copied"
      end

      context "change attribute" do
        let(:copy) { instance.foo(:baz) }
        it { expect(copy.foo).to eq :baz }
        it_behaves_like "instance is copied"
      end

      context "changes both freq and phase" do
        let(:copy) { instance.freq(220).phase(0.5) }
        it { expect(copy.freq).to eq 220 }
        it { expect(copy.phase).to be 0.5 }
        it_behaves_like "instance is copied"
      end
    end

    context "initialize with defaults" do
      subject(:instance) { subclass.new(rate: :audio) }

      describe "sets values" do
        it { expect(instance.foo).to be :bar }
        it { expect(instance.freq).to be 440 }
        it { expect(instance.phase).to be 0 }
      end
    end

    context "initialize with named params" do
      subject(:instance) do
        subclass.new(rate: :audio, foo: :baz, phase: 1, freq: 880)
      end

      describe "sets values" do
        it { expect(instance.foo).to be :baz }
        it { expect(instance.freq).to be 880 }
        it { expect(instance.phase).to be 1 }
      end
    end

    context "initialize with positional arguments" do
      context "one argument is passed" do
        subject(:instance) do
          subclass.new(:baz, 220, rate: :audio)
        end

        describe "sets values" do
          it { expect(instance.foo).to be :baz }
          it { expect(instance.freq).to be 220 }
          it { expect(instance.phase).to be 0 }
        end
      end

      context "all arguments are passed" do
        subject(:instance) do
          subclass.new(:baz, 220, 1, rate: :audio)
        end

        describe "sets values" do
          it { expect(instance.foo).to be :baz }
          it { expect(instance.freq).to be 220 }
          it { expect(instance.phase).to be 1 }
        end
      end

      context "argument is overriden" do
        subject(:instance) do
          subclass.new(:baz, 220, 1, freq: 300, rate: :audio)
        end

        describe "sets values" do
          it { expect(instance.foo).to be :baz }
          it { expect(instance.freq).to be 300 }
          it { expect(instance.phase).to be 1 }
        end
      end
    end

    context "different defaults for audio and control" do
      let(:subclass) do
        Class.new(Ugen::Base) do
          rates :audio, :control
          attributes foo: :bar
          inputs freq: { audio: 440, control: 10 }, phase: 0
        end
      end

      context "audio rate" do
        subject(:instance) { subclass.new(rate: :audio) }

        describe "sets values" do
          it { expect(instance.freq).to be 440 }
          it { expect(instance.phase).to be 0 }
        end
      end

      context "control rate" do
        subject(:instance) { subclass.new(rate: :control) }

        describe "sets values" do
          it { expect(instance.freq).to be 10 }
          it { expect(instance.phase).to be 0 }
        end
      end
    end
  end


  describe ".rate" do
    subject(:subclass) do
      Class.new(Ugen::Base) { rates :audio, :control }
    end

    let(:instance) { subclass.ar }

    describe "change rate" do
      let(:copy) { instance.rate(:control) }
      it { expect(copy.rate).to be :control }
      it_behaves_like "instance is copied"
    end

    describe "change to invalid rate" do
      subject { instance.rate(:demand) }
      it_behaves_like "doesn't allow rate"
    end
  end


  describe ".name" do
    subject(:subclass) do
      Class.new(Ugen::Base) { rates :audio, :control }
    end

    let(:instance) { subclass.ar }

    before do
      allow(subclass).to receive(:name) { "Scruby::Ugen::SinOsc"}
    end

    it { expect(instance.name).to eq "SinOsc"}
  end


  describe "equality" do
    subject(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio, :control
        inputs freq: 440, phase: 0
      end
    end

    let(:instance) { subclass.ar }
    it { expect(instance).to eq instance.rate(:audio) }
    it { expect(instance).not_to eq instance.rate(:control) }
    it { expect(instance).to eq instance.freq(440) }
    it { expect(instance).not_to eq instance.freq(220) }
  end


  describe "building graph" do
    subject(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio, :control
        inputs freq: 440, phase: 0
      end
    end

    let(:instance) { subclass.ar }
    let(:graph) { instance_double("Graph") }
    let(:server) { instance_double("Server") }
    let(:args) do
      { a: "simple", b: "something" }
    end

    it "builds a graph" do
      allow(Graph).to receive(:new).with(instance, args) { graph }
      expect(instance.build_graph(**args)).to eq graph
    end

    it "plays" do
      allow(Graph).to receive(:new).with(instance) { graph }
      expect(graph).to receive(:play).with(server, args) { graph }
      expect(instance.play(server, args)).to eq graph
    end
  end
end
