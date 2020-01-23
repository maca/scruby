# include Scruby
# include Ugens

# class MockUgen < Ugen
#   class << self; public :new; end
# end


# class SinOsc < Ugen
#   class << self
#     def ar(freq = 440.0, phase = 0.0) # not interested in muladd by now
#       new :audio, freq, phase
#     end

#     def kr(freq = 440.0, phase = 0.0)
#       new :control, freq, phase
#     end
#   end
# end

# # Mocks
# class ControlName; end
# class Env; end

# RSpec.describe DelegatorArray do

#   it "should have 'literal' notation" do
#     expect(d(1, 2)).to eq([ 1, 2 ])
#     expect(d(1, 2)).to be_instance_of(DelegatorArray)
#     expect(d([ 1, 2 ])).to eq(d(1, 2))
#   end

#   it "should allow nil" do
#     d(nil)
#   end

#   it "should return DelegatorArray" do
#     sig = SinOsc.ar([ 100, [ 100, 100 ]])
#     expect(sig).to be_a(DelegatorArray)
#   end

#   it "should convet to_da" do
#     expect([].to_da).to be_a(DelegatorArray)
#   end

#   it "should pass missing method" do
#     expect(d(1, 2).to_f).to eq(d(1.0, 2.0))
#   end

#   it "should return a DelegatorArray for muladd" do
#     expect(SinOsc.ar(100).muladd(1, 0.5)).to be_a(BinaryOpUGen)
#     expect(SinOsc.ar([ 100, [ 100, 100 ]]).muladd(0.5, 0.5)).to be_a(DelegatorArray)
#     # SinOsc.ar([100, [100, 100]]).muladd(1, 0.5).should be_a(DelegatorArray)
#   end


#   it "should pass method missing" do
#     expect(d(1, 2, 3).to_i).to eq([ 1.0, 2.0, 3.0 ])
#   end

#   shared_examples_for "aritmetic operand" do
#     before do
#       @numeric_op     = eval %{ d(1,2)   #{ @op } 3.0 }
#       @array_op       = eval %{ d(1,2)   #{ @op } d(1.0, 2.0) }
#       @asim_array_op1 = eval %{ d(1,2,3) #{ @op } d(1.0, 2.0) }
#     end

#     it "should do operation" do
#       expect(@numeric_op).to eq(@numeric_op)
#       expect(@numeric_op).to be_a(DelegatorArray)
#     end

#     it "should do operation with array of the same size" do
#       expect(@array_op).to eq(@array_result)
#       expect(@array_op).to be_a(DelegatorArray)
#     end

#     it "should do operation with array of diferent size (left bigger)" do
#       expect(@asim_array_op1).to eq(@asim_result1)
#       expect(@asim_array_op1).to be_a(DelegatorArray)
#     end

#     it "should blow passing nil" do
#       expect { d(1, 2, 3, nil) + 1 }.to raise_error(NoMethodError)
#     end

#     it "should blow pass nil" do
#       actual   = eval %{ d(1,2,3) #{ @op } MockUgen.new(:audio, 2)}
#       expected = BinaryOpUGen.new(@op.to_sym, [ 1, 2, 3 ], MockUgen.new(:audio, 2))
#       expect(actual).to eq(expected)
#     end

#     it "should allow passing an MockUgen Array" do
#       eval %{ SinOsc.ar([100, [100, 100]]) #{@op} SinOsc.ar }
#     end
#   end

#   describe "should override sum" do
#     before do
#       @op           = "+"
#       @array_result = d(1 + 1.0, 2 + 2.0)
#       @asim_result1 = d(1 + 1.0, 2 + 2.0, 3)
#     end
#     it_should_behave_like "aritmetic operand"
#   end

#   describe "should override subs" do
#     before do
#       @op           = "-"
#       @array_result = d(1 - 1.0, 2 - 2.0)
#       @asim_result1 = d(1 - 1.0, 2 - 2.0, 3)
#     end
#   end

#   describe "should override mult" do
#     before do
#       @op           = "*"
#       @array_result = d(1 * 1.0, 2 * 2.0)
#       @asim_result1 = d(1 * 1.0, 2 * 2.0, 3)
#     end
#     it_should_behave_like "aritmetic operand"
#   end

#   describe "should override div" do
#     before do
#       @op           = "/"
#       @array_result = d(1 / 1.0, 2 / 2.0)
#       @asim_result1 = d(1 / 1.0, 2 / 2.0, 3)
#     end
#     it_should_behave_like "aritmetic operand"
#   end

# end
