RSpec.describe Env do
  subject(:env) { Env.new(levels: [ 0, 1 ].cycle(4), times: [ 0.1 ],
                          release_at: 3, loop_at: 4) }


  describe "initialize" do
    context "levels are smaller than times array" do
      subject(:env) { Env.new(levels: (1..4), times: (1..8)) }

      it { expect(env.levels).to eq (1..4) }
      it { expect(env.times).to eq (1..3).to_a }
    end

    context "levels are greater than times array" do
      subject(:env) { Env.new(levels: (1..8), times: (1..3)) }

      it { expect(env.levels).to eq (1..8) }
      it { expect(env.times).to eq [ 1, 2, 3, 1, 2, 3, 1 ] }
    end

    describe "defaults" do
      it { expect(Env.new.levels).to eq [ 0, 1, 0 ] }
      it { expect(Env.new.times).to eq [ 1, 1 ] }
      it { expect(Env.new.curves).to eq %i(linear) }
      it { expect(Env.new.release_at).to be_nil }
      it { expect(Env.new.loop_at).to be_nil }
    end
  end


  describe "time calculations" do
    describe "duration" do
      it { expect(env.duration).to be 0.1 * 7 }
      it { expect(Env.new.duration).to be 2 }
    end

    describe "sustained?" do
      it { expect(env.sustained?).to be true }
      it { expect(Env.new.sustained?).to be false }
    end

    describe "release time" do
      it { expect(Env.new(release_at: 0).release_time).to be 2 }
      it { expect(Env.new(release_at: 1).release_time).to be 1 }
      it { expect(Env.new(release_at: 2).release_time).to be 0 }
    end

    describe "at time" do
      context "step env" do
        subject(:env) { Env.new(curves: :step) }

        it { expect(env.at_time(0)).to eq 1 }
        it { expect(env.at_time(0.6)).to eq 1 }
        it { expect(env.at_time(1)).to eq 0 }
      end

      context "hold env" do
        subject(:env) { Env.new(curves: :hold) }

        it { expect(env.at_time(0)).to eq 0 }
        it { expect(env.at_time(0.6)).to eq 0 }
        it { expect(env.at_time(1)).to eq 1 }
      end

      context "linear env" do
        subject(:env) { Env.new(times: [ 2, 3 ]) }

        it { expect(env.at_time(0)).to eq 0 }
        it { expect(env.at_time(0.4)).to eq 0.2 }
        it { expect(env.at_time(1)).to eq 0.5 }
        it { expect(env.at_time(1.8)).to be_within(0.0001).of(0.9) }
        it { expect(env.at_time(4.3)).to be_within(0.0001).of(0.2333) }
        it { expect(env.at_time(env.duration)).to be 0.0 }
      end

      context "exponential env" do
        subject(:env) { Env.new(levels: [ 1, 2 ], curves: :exp) }

        it { expect(env.at_time(0.5)).to be_within(0.001).of(1.4142) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(1.8660) }
      end

      context "sine env" do
        subject(:env) { Env.new(curves: :sin) }

        it { expect(env.at_time(0.3)).to be_within(0.001).of(0.2061) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(0.9755) }
      end

      context "welch env" do
        subject(:env) { Env.new(curves: :wel) }

        it { expect(env.at_time(0.3)).to be_within(0.001).of(0.4539) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(0.9876) }
      end

      context "squared env" do
        subject(:env) { Env.new(curves: :sqr) }

        it { expect(env.at_time(0.3)).to be_within(0.001).of(0.09) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(0.81) }
      end

      context "cubed env" do
        subject(:env) { Env.new(curves: :cub) }

        it { expect(env.at_time(0.3)).to be_within(0.001).of(0.027) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(0.729) }
      end

      context "numeric curve env" do
        subject(:env) { Env.new(curves: -5) }

        it { expect(env.at_time(0.3)).to be_within(0.001).of(0.7821) }
        it { expect(env.at_time(0.9)).to be_within(0.001).of(0.9955) }
      end
    end

    describe "interpolate" do
      context "discreet step" do
        shared_examples "values are interpolated" do
          it { expect(values.size).to be 3 }
          it { expect(values[0]).to be 0.0 }
          it { expect(values[1]).to be 1.0 }
          it { expect(values[0]).to be 0.0 }
        end

        describe "interpolate block given" do
          let(:values) { [] }

          subject!(:env) do
            Env.new.interpolate(1) { |v| values.push(v) }
          end

          it { expect(env).to be_an(Env) }
          it_behaves_like "values are interpolated"
        end

        context "no block given" do
          subject(:enum) { Env.new.interpolate(1) }

          it { expect(enum).to be_a(Enumerator) }
          it { expect(enum.size).to be 3 }

          it_behaves_like "values are interpolated" do
            let(:values) { enum.to_a }
          end
        end
      end

      context "float step" do
        shared_examples "values are interpolated" do
          it { expect(values.size).to be 21 }
          it { expect(values[0]).to be 0.0 }
          it { expect(values[1]).to be_within(0.0001).of(0.1) }
          it { expect(values[9]).to be_within(0.0001).of(0.9) }
          it { expect(values[10]).to be_within(0.0001).of(1) }
          it { expect(values[13]).to be_within(0.0001).of(0.7) }
          it { expect(values.last).to be 0.0 }
        end

        describe "interpolate block given" do
          let(:values) { [] }

          subject!(:env) do
            Env.new.interpolate(0.1) { |v| values.push(v) }
          end

          it { expect(env).to be_an(Env) }
          it_behaves_like "values are interpolated"
        end

        context "no block given" do
          subject(:enum) { Env.new.interpolate(0.1) }

          it { expect(enum).to be_a(Enumerator) }
          it { expect(enum.size).to be 21 }

          it_behaves_like "values are interpolated" do
            let(:values) { enum.to_a }
          end
        end
      end
    end
  end


  describe "Ugen building" do
    let(:env_gen) { instance_double("EnvGen") }

    describe "control" do
      before { allow(EnvGen)
                 .to receive(:kr).with(env, :a, :b, c: 1) { env_gen } }

      it { expect(env.kr(:a, :b, c: 1)).to eq env_gen }
    end

    describe "audio" do
      before { allow(EnvGen)
                 .to receive(:ar).with(env, :a, :b, c: 1) { env_gen } }

      it { expect(env.ar(:a, :b, c: 1)).to eq env_gen }
    end
  end


  describe "build" do
    let(:env) { Env.new }
    let(:result) { [ 0, 2, -99, -99, 1, 1, 1, 0, 0, 1, 1, 0 ] }

    it { expect(env).to encode_as(result) }
  end


  describe "predefined envelopes" do
    it { expect(Env.triangle).to be_an Env }
    it { expect(Env.sine).to be_an Env }
    it { expect(Env.perc).to be_an Env }
    it { expect(Env.linen).to be_an Env }
    it { expect(Env.cutoff).to be_an Env }
    it { expect(Env.dadsr).to be_an Env }
    it { expect(Env.adsr).to be_an Env }
    it { expect(Env.asr).to be_an Env }
    # it { expect(Env.circle).to be_an Env }
  end


  describe "equality" do
    it_behaves_like "is equatable"
    it { expect(Env.new(curves: :lin)).to eq Env.new(curves: :linear) }
  end
end
