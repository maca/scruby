RSpec.describe Attributes do
  let(:extended_class) do
    Class.new do
      extend Attributes

      attributes do
        attribute :foo
        attribute :bar, nil
        attribute :baz, false
        attribute :qux, :hello
      end
    end
  end

  describe "initialize with no attributes" do
    subject(:instance) { extended_class.new }
    it { expect(instance.foo).to be nil }
    it { expect(instance.bar).to be nil }
    it { expect(instance.baz).to be false }
    it { expect(instance.qux).to be :hello }
  end

  describe "override attribute with falsy" do
    subject(:instance) do
      extended_class.new(
        foo: false,
        bar: false,
        baz: false,
        qux: false
      )
    end

    it { expect(instance.foo).to be false }
    it { expect(instance.bar).to be false }
    it { expect(instance.baz).to be false }
    it { expect(instance.qux).to be false }
  end

  describe "initialize with unknown attribute" do
    it { expect { extended_class.new(foobar: :hi) }
           .to raise_exception(ArgumentError) }
  end
end
