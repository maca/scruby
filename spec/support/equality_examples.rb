RSpec.shared_examples_for "is equatable" do
  it { expect(described_class.ancestors)
         .to include(Scruby::Equatable) }
end
