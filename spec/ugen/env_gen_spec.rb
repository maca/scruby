RSpec.describe Ugen::EnvGen do
  it_behaves_like "has done action"

  describe "EnvGen as graph node" do
    context "for default Env with defaults" do
      let(:ugen) { EnvGen.kr(Env.new) }

      include_context "node with graph"
      include_context "node with graph constants" do
        let(:constants) do
          [ Graph::Constant.new(1),
            Graph::Constant.new(0),
            Graph::Constant.new(2),
            Graph::Constant.new(-99)
          ]
        end
      end

      let(:expected) do
        [
          6, 69, 110, 118, 71, 101, 110, 1, 0, 0, 0, 17, 0, 0, 0, 1,
          0, 0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0,
          0, -1, -1, -1, -1, 0, 0, 0, 1, -1, -1, -1, -1, 0, 0, 0, 0,
          -1, -1, -1, -1, 0, 0, 0, 1, -1, -1, -1, -1, 0, 0, 0, 1, -1,
          -1, -1, -1, 0, 0, 0, 2, -1, -1, -1, -1, 0, 0, 0, 3, -1, -1,
          -1, -1, 0, 0, 0, 3, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1,
          -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1,
          0, 0, 0, 1, -1, -1, -1, -1, 0, 0, 0, 1, -1, -1, -1, -1, 0,
          0, 0, 0, -1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1, 0, 0,
          0, 1, 1
        ].pack("C*")
      end

      subject(:node) { Graph::UgenNode.build(graph, ugen) }

      it { expect(node).to encode_as(expected) }
    end
  end
end
