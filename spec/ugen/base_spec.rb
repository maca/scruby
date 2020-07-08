RSpec.describe Ugen::Base do
  describe "multichannel" do
    subject(:subclass) do
      Class.new(Ugen::Base) do
        rates :audio
        inputs ins: nil
        attributes colors: nil
      end
    end

    describe "to multichannel" do
      let(:instance) { subclass.new }

      it { expect(instance.channels(2))
             .to eq MultiChannel.new([ instance ] * 2)}

      it { expect(instance.channels(3))
             .to eq MultiChannel.new([ instance ] * 3)}
    end

    context "passing multichannel instance" do
      let(:instance) do
        subclass.new(ins: MultiChannel.new([subclass.new, subclass.new]))
      end

      it { expect(instance.ins).to eq [ subclass.new, subclass.new ] }
    end

    context "passing single channel multichannel instance" do
      let(:instance) do
        subclass.new(ins: MultiChannel.new([subclass.new]))
      end

      it { expect(instance.ins).to eq subclass.new }
    end

    context "passing single channel multichannel instance as attr" do
      let(:instance) do
        subclass.new(colors: MultiChannel.new([subclass.new]))
      end

      it { expect(instance.colors).to eq MultiChannel.new([subclass.new]) }
    end
  end
end
