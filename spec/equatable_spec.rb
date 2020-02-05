RSpec.describe Equatable do
  include Scruby

  let(:equatable_class) do
    Class.new do
      include Equatable

      def initialize(value)
        @value = value
      end
    end
  end

  describe "equality" do
    let(:value) { 440 }

    it { expect(equatable_class.new(value))
           .to eq equatable_class.new(value) }

    it { expect(equatable_class.new(value))
           .not_to eq equatable_class.new(value + 1) }
  end
end
