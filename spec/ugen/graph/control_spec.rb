RSpec.describe Ugen::Graph::Control do
  include Scruby

  describe "building a graph" do
    let(:subject) { described_class.new(:a_control, 1) }
  end
end
