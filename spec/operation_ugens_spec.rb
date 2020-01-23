# include Scruby
# include Ugens

# class MockUgen < Ugen
#   class << self; public :new; end
# end

# RSpec.describe UnaryOpUGen do
#   ::RATES = %i(scalar demand control audio).freeze

#   before do
#     @scalar  = MockUgen.new :scalar
#     @demand  = MockUgen.new :demand
#     @control = MockUgen.new :control
#     @audio   = MockUgen.new :audio
#   end

#   describe UnaryOpUGen do

#     before do
#       @op = UnaryOpUGen.new(:neg, @audio)
#     end

#     it "should return special index" do
#       expect(UnaryOpUGen.new(:neg, @audio).special_index).to     eq(0)
#       expect(UnaryOpUGen.new(:bitNot, @audio).special_index).to  eq(4)
#       expect(UnaryOpUGen.new(:abs, @audio).special_index).to     eq(5)
#       expect(UnaryOpUGen.new(:asFloat, @audio).special_index).to eq(6)
#     end

#     it "should accept just one input" do
#       expect{ UnaryOpUGen.new(:neg, @audio, @demand) }.to raise_error(ArgumentError)
#     end

#     it "should just accept defined operators" # do
#     #    lambda{ UnaryOpUGen.new(:not_operator, @audio) }.should raise_error( ArgumentError )
#     #  end

#     it "should get max rate" do
#       expect(UnaryOpUGen.send(:get_rate, @scalar, @demand)).to                       eq(:demand)
#       expect(UnaryOpUGen.send(:get_rate, @scalar, @demand, @audio)).to               eq(:audio)
#       expect(UnaryOpUGen.send(:get_rate, @scalar, [ @demand, [ @control, @audio ]])).to eq(:audio)
#     end

#     it do
#       expect(UnaryOpUGen.new(:neg, @audio)).to be_instance_of(UnaryOpUGen)
#     end

#     it "should set rate" do
#       expect(UnaryOpUGen.new(:neg, @audio).rate).to  eq(:audio)
#       expect(UnaryOpUGen.new(:neg, @scalar).rate).to eq(:scalar)
#     end

#     it "should set operator" do
#       expect(UnaryOpUGen.new(:neg, @audio).operator).to eq(:neg)
#     end
#   end

#   describe BinaryOpUGen do

#     before do
#       @arg_array = [ @audio, [ @scalar, @audio, [ @demand, [ @control, @demand ]]]]
#       @op_arr = BinaryOpUGen.new(:+, @audio, @arg_array)
#     end

#     it "should return special index" do
#       expect(BinaryOpUGen.new(:+, @audio, @audio).special_index).to eq(0)
#       expect(BinaryOpUGen.new(:-, @audio, @audio).special_index).to eq(1)
#       expect(BinaryOpUGen.new(:*, @audio, @audio).special_index).to eq(2)
#       expect(BinaryOpUGen.new(:/, @audio, @audio).special_index).to eq(4)
#     end

#     it "should accept exactly two inputs" do
#       expect{ BinaryOpUGen.new(:+, @audio) }.to raise_error(ArgumentError)
#       expect{ BinaryOpUGen.new(:+, @audio, @demand, @demand) }.to raise_error(ArgumentError)
#     end

#     it "should have correct inputs and operator when two inputs" do
#       arr = BinaryOpUGen.new(:+, @audio, @demand)
#       expect(arr.inputs).to   eq([ @audio, @demand ])
#       expect(arr.operator).to eq(:+)
#       expect(arr.rate).to     eq(:audio)
#     end

#     it "should accept array as input" do
#       expect(BinaryOpUGen.new(:+, @audio, [ @audio, @scalar ])).to be_instance_of(DelegatorArray)
#     end

#     it "should return an array of UnaryOpUGens" do
#       @op_arr.flatten.map { |op| expect(op).to be_instance_of(BinaryOpUGen)  }
#     end

#     it "should set rate for all operations" do
#       @op_arr.flatten.map { |op| expect(op.rate).to eql(:audio)  }
#     end

#     it "should set operator for all operations" do
#       @op_arr.flatten.map { |op| expect(op.operator).to eql(:+)  }
#     end

#     it "should set correct inputs when provided an array" do
#       arr = BinaryOpUGen.new(:+, @control, [ @audio, @scalar ])
#       expect(arr.first.inputs).to eq([ @control, @audio ])
#       expect(arr.last.inputs).to  eq([ @control, @scalar ])
#     end

#     it "should create the correct number of operations" do
#       expect(@op_arr.flatten.size).to eql(@arg_array.flatten.size)
#     end

#     it "should replicate the array passed" do
#       last = lambda do |i|
#         if i.instance_of?(BinaryOpUGen)
#           expect(i.inputs.first).to eq(@audio)
#           i.inputs.last
#         else
#           i.map{ |e| last.call(e) }
#         end
#       end
#       expect(last.call(@op_arr)).to eq(@arg_array)
#     end

#     it "should accept numbers as inputs" do
#       arr = BinaryOpUGen.new(:+, @control, [ 100, 200.0 ])
#       expect(arr.first.inputs).to eq([ @control, 100 ])
#       expect(arr.last.inputs).to  eq([ @control, 200.0 ])
#       expect(BinaryOpUGen.new(:+, 100, @control).inputs).to eq([ 100, @control ])
#     end

#     it "should accept array as input" do
#       arr = BinaryOpUGen.new(:+, [ @audio, @scalar ], @control)
#       expect(arr.first.inputs).to eq([ @audio, @control ])
#       expect(arr.last.inputs).to  eq([ @scalar, @control ])
#     end

#     it "should accept numeric arg as first arg" do
#       arr = BinaryOpUGen.new(:+, 1, @control)
#       expect(arr.inputs).to eq([ 1, @control ])
#     end
#   end

#   describe MulAdd do
#     it do
#       expect(MulAdd.new(@audio, 0.5, 0.5)).to be_instance_of(MulAdd)
#     end

#     it do
#       expect(MulAdd.new(@audio, 0.5, 0.5).rate).to   eq(:audio)
#     end

#     it do
#       expect(MulAdd.new(@audio, 0.5, 0.5).inputs).to eq([ @audio, 0.5, 0.5 ])
#     end

#     it "should not be instance of MulAdd" do
#       unary_op = double "neg"
#       mult     = double "mult"
#       minus    = double "minus"
#       plus     = double "plus"

#       expect(@audio).to receive(:neg).and_return(unary_op)
#       expect(@audio).to receive(:*).and_return(mult)
#       add = double("0.5", :- => minus, :zero? => false)
#       expect(@audio).to receive(:+).and_return(plus)

#       expect(MulAdd.new(@audio, 0, 0.5)).to be_instance_of(Float)
#       expect(MulAdd.new(@audio, 1, 0)).to   eq(@audio)
#       expect(MulAdd.new(@audio, -1, 0)).to  eq(unary_op)
#       expect(MulAdd.new(@audio, 0.5, 0)).to eq(mult)
#       expect(MulAdd.new(@audio, -1, add)).to eq(minus)
#       expect(MulAdd.new(@audio, 1, 0.5)).to eq(plus)
#     end

#     it "should accept ugens" do
#       expect(MulAdd.new(@audio, @audio, 1)).to be_instance_of(MulAdd)
#       expect(MulAdd.new(@audio, @audio, @scalar)).to be_instance_of(MulAdd)

#       bin_op_ugen = double "binary op ugen"
#       allow(@audio).to receive(:*).and_return bin_op_ugen
#       expect(MulAdd.new(@audio, @audio, 0)).to eq(bin_op_ugen)
#     end

#   end

# end
