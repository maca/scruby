# module UgenTest
# end

# class Klass
# end

# include Scruby
# include Ugens


# RSpec.describe Ugens do
#   before do
#     @udefs = YAML.load(File.open("#{__dir__}/../lib/scruby/ugens/ugen_defs.yaml"))
#   end

#   it "should define Ugen classes" do
#     @udefs.each_pair { |key, _val| expect(eval(key)).not_to be_nil  }
#   end

#   it "each ugen should be Ugen subclass" do
#     @udefs.each_pair { |key, _val| expect(eval(key).superclass).to eql(Scruby::Ugens::Ugen)  }
#   end

#   it "should resond to :ar and :kr" do
#     expect(Vibrato).to respond_to(:ar)
#     expect(Vibrato).to respond_to(:kr)
#   end

#   it "should use default values and passed values" do
#     expect(Gendy1).to receive(:new).with(:audio, 10, 20, 1, 1, 550, 660, 0.5, 0.5, 12, 1).and_return(double("ugen", muladd: nil))
#     Gendy1.ar 10, 20, knum: 1, minfreq: 550
#   end

#   it "should raise argumen error if not passed required" do
#     allow(Gendy1).to receive(:new)
#     expect { Gendy1.ar }.to raise_error(ArgumentError)
#   end

#   it "should not accept more than the required arguments" do
#     expect { SinOsc.ar(1, 2, 3, 4, 5, 6) }.to raise_error(ArgumentError)
#   end

#   it "should initialize using demand" do
#     expect(Dbrown.new(1, 2, 3, 4).inputs).to eq([ 1, 2, 3, 4 ])
#   end

#   it "should have public new method for scalar" do
#     ExpRand.new(1, 2)
#   end

#   it "should output params"
# end
