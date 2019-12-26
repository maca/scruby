# frozen_string_literal: true

RSpec.describe Ugen::Input do
  include Scruby
  include Ugens

  describe ".value" do
    let(:value) { 1 }
    subject(:input) { described_class.new(value) }
    it { expect(input.value).to eq value }
  end
end
