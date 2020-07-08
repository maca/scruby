RSpec.describe Ugen::MultiChannel do
  it "compares max size" do
    property_of { [ range(1, 10), range(1, 10) ] }.check do |n1, n2|
      size = MultiChannel.new([1] * n1).max_size([1] * n2)
      expect(size).to eq([n1, n2].max)
    end
  end

  describe "enumerable methods" do
    it "converst to array" do
      property_of { range(1, 10).times.to_a }.check do |a|
        expect(MultiChannel.new(a).to_a).to eq a
      end
    end

    it "returns size" do
      property_of { range(1, 10).times.to_a }.check do |a|
        expect(MultiChannel.new(a).size).to eq a.size
      end
    end

    it "returns enumerator" do
      property_of { range(1, 10).times.to_a }.check do |a|
        expect(MultiChannel.new(a).each.to_a).to eq a.each.to_a
      end
    end

    it "maps" do
      property_of { range(1, 10).times.to_a }.check do |a|
        expect(MultiChannel.new(a).map(&:to_s)).to eq a.map(&:to_s)
      end
    end

    describe "zip" do
      it "it cycles first" do
        property_of { [ range(1, 10).times.to_a,
                        range(1, 10).times.to_a ] }
          .check do |a1, a2|

          size = [a1, a2].max_by(&:size).size
          zipped = MultiChannel.new(a1).zip(a2)
          expect(zipped.map(&:first)).to eq(a1.cycle.take(size))
        end
      end

      it "it cycles second" do
        property_of { [ range(1, 10).times.to_a,
                        range(1, 10).times.to_a ] }
          .check do |a1, a2|

          size = [a1, a2].max_by(&:size).size
          zipped = MultiChannel.new(a1).zip(a2)
          expect(zipped.map(&:last)).to eq(a2.cycle.take(size))
        end
      end
    end
  end

  describe "rate" do
    context "is audio" do
      let(:inputs) do
        Ugen::RATES[0..4].map { |r| instance_double("Gen", rate: r)  }
      end

      it { expect(described_class.new(inputs).rate).to eq :audio }
    end

    context "is control" do
      let(:inputs) do
        Ugen::RATES[0..3].map { |r| instance_double("Gen", rate: r)  }
      end

      it { expect(described_class.new(inputs).rate).to eq :control }
    end

    context "is demand" do
      let(:inputs) do
        Ugen::RATES[0..2].map { |r| instance_double("Gen", rate: r)  }
      end

      it { expect(described_class.new(inputs).rate).to eq :demand }
    end

    context "is trigger" do
      let(:inputs) do
        Ugen::RATES[0..1].map { |r| instance_double("Gen", rate: r)  }
      end

      it { expect(described_class.new(inputs).rate).to eq :trigger }
    end

    context "is scalar" do
      let(:inputs) do
        Ugen::RATES[0..0].map { |r| instance_double("Gen", rate: r)  }
      end

      it { expect(described_class.new(inputs).rate).to eq :scalar }
    end
  end
end
