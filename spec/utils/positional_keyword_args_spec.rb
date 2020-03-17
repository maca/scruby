RSpec.describe Utils::PositionalKeywordArgs do
  let(:klass) do
    Class.new do
      include Utils::PositionalKeywordArgs
      public :positional_keyword_args
    end
  end

  let(:instance) { klass.new }

  let(:defaults) do
    { a: 1, b: 2, c: 3, d: 4 }
  end

  let(:args) { [] }
  let(:kwargs) { {} }

  subject(:result) do
    instance.positional_keyword_args(defaults, *args, **kwargs)
  end


  describe "success" do
    context "default valuess" do
      it "returns defaults" do
        expect(result).to eq(a: 1, b: 2, c: 3, d: 4)
      end
    end

    context "some positional arguments given" do
      let(:args) { %i(x y z) }

      it "mixes defaults with positional arg values" do
        expect(result).to eq(a: :x, b: :y, c: :z, d: 4)
      end
    end

    context "passing keyword arguments" do
      let(:kwargs) { { b: :x, c: :y, d: :z } }

      it "mixes defaults with positional arg values" do
        expect(result).to eq(a: 1, b: :x, c: :y, d: :z)
      end
    end

    describe "keyword arguments override positional arguments" do
      let(:args) { %i(foo bar baz) }
      let(:kwargs) { { b: :x, d: :z } }

      it "mixes defaults with positional arg values" do
        expect(result).to eq(a: :foo, b: :x, c: :baz, d: :z)
      end
    end
  end


  describe "failure" do
    context "too many arguments given" do
      let(:args) { (1..5) }
      let(:msg) do
        "(wrong number of arguments (given 5, expected less than 4))"
      end

      it { expect { result }.to raise_error(ArgumentError, msg) }
    end

    context "too many arguments given" do
      let(:kwargs) { { baz: 1, hoge: 2 } }
      let(:msg) do
        "(unknown keywords: :baz, :hoge)"
      end

      it { expect { result }.to raise_error(ArgumentError, msg) }
    end
  end
end
