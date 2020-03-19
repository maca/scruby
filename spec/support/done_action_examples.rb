RSpec.shared_examples_for "has done action" do
  let(:ugen) { described_class.kr(done_action: :free) }
  it { expect(ugen.done_action).to be 2 }
end
