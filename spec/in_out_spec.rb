# include Scruby
# include Ugens

# class SinOsc < Ugen
#   # not interested in muladd
#   def self.ar(freq = 440.0, phase = 0.0)
#     new :audio, freq, phase
#   end
# end

# class MockUgen < Ugen
#   class << self; public :new; end
# end

# RSpec.describe In do
#   before do
#     @sdef = double("ugen", children: [])
#     expect(Ugen).to receive(:synthdef).at_least(:once).and_return(@sdef)

#     @proxy   = double("output proxy")
#     @proxies = (1..10).map{ @proxy }
#     allow(OutputProxy).to receive(:new).and_return(@proxy)

#     @ar = In.ar 3
#   end

#   it "respond to #kr and #ar" do
#     expect(In).to respond_to(:kr)
#     expect(In).to respond_to(:ar)
#   end

#   it "should spec #ar" do
#     expect(@ar).to be_instance_of(DelegatorArray)
#     expect(@ar.size).to eq(1)
#     expect(@ar.first).to eq(@proxy)
#   end

#   it "should have bus as input" do
#     expect(@sdef.children.first.inputs).to eq([ 3 ])
#   end

#   it "should have ten channels" do
#     expect(In.ar(0, 10)).to eq(@proxies)
#   end

#   it "should describe passing arrays to initialize"

# end


# RSpec.describe Out do
#   shared_examples_for "Out" do
#     before do
#       @sdef = double "sdef", children: [], constants: [ 400, 0 ]
#       expect(Ugen).to receive(:synthdef).at_least(:once).and_return @sdef
#     end

#     it "should accept one ugen" do
#       @ugen1 = MockUgen.new :audio
#       expect(@class.kr(1, @ugen1)).to eq(0.0)
#       expect(@sdef.children.size).to eq(2)

#       out = @sdef.children.last
#       expect(out.rate).to     eq(:control)
#       expect(out.inputs).to   eq([ 1, @ugen1 ])
#       expect(out.channels).to eq([])
#     end

#     it "should accept several inputs from array" do
#       @ugen1 = MockUgen.new :audio
#       @ugen2 = MockUgen.new :audio
#       @ugen3 = MockUgen.new :audio

#       @class.kr 1, [ @ugen1, @ugen2, @ugen3 ]
#       expect(@sdef.children.size).to eq(4)

#       out = @sdef.children.last
#       expect(out.inputs).to eq([ 1, @ugen1, @ugen2, @ugen3 ])
#     end

#     it "should accept several inputs" do
#       @ugen1 = MockUgen.new :audio
#       @ugen2 = MockUgen.new :audio
#       @ugen3 = MockUgen.new :audio

#       @class.kr 1, @ugen1, @ugen2, @ugen3
#       expect(@sdef.children.size).to eq(4)

#       out = @sdef.children.last
#       expect(out.inputs).to eq([ 1, @ugen1, @ugen2, @ugen3 ])
#     end

#     it "should validate rate"
#     it "should substitute zero with silence"
#     it "should spec passing array on init"
#   end

#   describe Out do
#     before do
#       @class = Out
#     end
#     it_should_behave_like "Out"
#   end

#   describe ReplaceOut do
#     before do
#       @class = Out
#     end
#     it_should_behave_like "Out"
#   end
# end
