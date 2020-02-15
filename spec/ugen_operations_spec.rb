# class MockUgen < Ugen
#   class << self; public :new; end
# end

# RSpec.describe UgenOperations do

#   before do
#     @ugen  = MockUgen.new :audio
#     @ugen2 = MockUgen.new :audio
#   end

#   describe "binary operations" do
#     it "should sum" do
#       sum = @ugen + @ugen2
#       expect(sum).to be_instance_of(BinaryOpUGen)
#     end

#     it "should sum integer" do
#       sum = @ugen + 1.0
#       expect(sum).to be_instance_of(BinaryOpUGen)
#     end

#     it "should raise argument error" do
#       expect { @ugen + :hola }.to raise_error(NoMethodError)
#     end
#   end

#   describe "unary operations" do
#     it "should do unary op" do
#       op = @ugen.distort
#       expect(op).to be_instance_of(UnaryOpUGen)
#       expect(op.inputs).to eq([ @ugen ])
#     end
#   end

#   describe Numeric do
#     it "do unary operation" do
#       expect(1.distort).to eq(UnaryOpUGen.new(:distort, 1))
#     end

#     it "should use original +" do
#       sum = 1 + 1
#       expect(sum).to eq(2)
#     end

#     it "should set the correct inputs and operator for the binopugen" do
#       sum = 1.0 + @ugen
#       expect(sum).to eq(BinaryOpUGen.new(:+, 1.0, @ugen))
#     end

#     it "ugen should sum numeric" do
#       sum = @ugen + 1
#       expect(sum).to eq(BinaryOpUGen.new(:+, @ugen, 1))
#     end

#     it "ugen should sum array" do
#       sum = @ugen * d(1, 2)
#       expect(sum).to eq(d(BinaryOpUGen.new(:*, @ugen, 1), BinaryOpUGen.new(:*, @ugen, 2)))
#     end
#   end

#   describe DelegatorArray do
#     before do
#       @ugen = MockUgen.new :audio
#     end

#     it "do binary operation" do
#       expect(d(@ugen).distort).to eq(d(@ugen.distort))
#     end

#     it "should do binary operation" do
#       op = d(1, 2) * @ugen
#       expect(op).to be_a(DelegatorArray)
#       expect(op).to eq(d(BinaryOpUGen.new(:*, 1, @ugen), BinaryOpUGen.new(:*, 2, @ugen)))
#     end
#   end

# end


# # methods overriden by UgenOperations inclusion:
# # Fixnum#+ Fixnum#gcd Fixnum#/ Fixnum#round Fixnum#lcm Fixnum#div Fixnum#- Fixnum#>= Fixnum#* Fixnum#<=
# # Float#+ Float#/ Float#round Float#div Float#- Float#>= Float#* Float#<=
# # changed max and min to maximum and minimum because the override Array#max and Array#min wich take no args
