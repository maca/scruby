# include Scruby
# include Ugens

# class MockUgen < Ugen
#   class << self; public :new; end
# end

# RSpec.describe "IO ugens" do
#   describe DiskOut, "one channel" do
#     before do
#       @sdef = SynthDef.new :out do |bufnum|
#         @out = DiskOut.ar bufnum, WhiteNoise.ar
#       end
#     end

#     it "should output zero" do
#       expect(@out).to eq(0.0)
#     end

#     it "should encode correctly" do
#       expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 6, 98, 117, 102, 110, 117, 109, 0, 0, 0, 3, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 1, 0, 0, 1, 10, 87, 104, 105, 116, 101, 78, 111, 105, 115, 101, 2, 0, 0, 0, 1, 0, 0, 2, 7, 68, 105, 115, 107, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ]
#       expect(@sdef.encode).to eq(expected.pack("C*"))
#     end
#   end

#   describe DiskOut, "two channel" do
#     before do
#       @sdef = SynthDef.new :out do |bufnum|
#         @out = DiskOut.ar bufnum, [ WhiteNoise.ar, WhiteNoise.ar ]
#       end
#       @sdef2 = SynthDef.new :out do |bufnum|
#         @out2 = DiskOut.ar bufnum, WhiteNoise.ar, WhiteNoise.ar
#       end
#     end

#     it "should output zero" do
#       expect(@out).to eq(0.0)
#     end

#     it "should encode the same" do
#       expect(@sdef.encode).to eq(@sdef2.encode)
#     end

#     it "should encode correctly" do
#       expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 6, 98, 117, 102, 110, 117, 109, 0, 0, 0, 4, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 1, 0, 0, 1, 10, 87, 104, 105, 116, 101, 78, 111, 105, 115, 101, 2, 0, 0, 0, 1, 0, 0, 2, 10, 87, 104, 105, 116, 101, 78, 111, 105, 115, 101, 2, 0, 0, 0, 1, 0, 0, 2, 7, 68, 105, 115, 107, 79, 117, 116, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 0 ]
#       expect(@sdef.encode).to eq(expected.pack("C*"))
#     end
#   end

#   shared_examples_for "DiskIn" do
#     before do
#       @sdef = SynthDef.new :in do
#         @proxies = @class.send :ar, @channels, *@inputs
#       end
#       @instance = @proxies.first.source
#     end

#     it "should output a DelegatorArray" do
#       expect(@proxies).to be_a(DelegatorArray)
#     end

#     it "should have correct rate" do
#       expect(@instance.rate).to eq(:audio)
#     end

#     it "should return an array of output proxies" do
#       expect(@proxies.size).to eq(@channels)
#       @proxies.each_with_index do |proxy, i|
#         expect(proxy.source).to be_a(@class)
#         expect(proxy).to be_a(OutputProxy)
#         expect(proxy.output_index).to eq(i)
#       end
#     end

#     it "should set inputs" do
#       expect(@instance.inputs).to eq(@inputs)
#     end

#     it "should encode" do
#       expect(@sdef.encode).to eq(@expected.pack("C*"))
#     end
#   end

#   describe DiskIn, "single channel" do
#     before do
#       @channels = 1
#       @inputs   = 1, 0
#       @class    = DiskIn
#       @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 105, 110, 0, 2, 63, -128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 68, 105, 115, 107, 73, 110, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 0, 0 ]
#     end
#     it_should_behave_like "DiskIn"
#   end

#   describe DiskIn, "two channels" do
#     before do
#       @channels = 2
#       @inputs   = 1, 0
#       @class    = DiskIn
#       @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 105, 110, 0, 2, 63, -128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 68, 105, 115, 107, 73, 110, 2, 0, 2, 0, 2, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 2, 0, 0 ]
#     end
#     it_should_behave_like "DiskIn"
#   end

#   describe VDiskIn, "single channel" do
#     before do
#       @channels = 1
#       @inputs   = 1, 2, 3, 4
#       @class    = VDiskIn
#       @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 105, 110, 0, 4, 63, -128, 0, 0, 64, 0, 0, 0, 64, 64, 0, 0, 64, -128, 0, 0, 0, 0, 0, 0, 0, 1, 7, 86, 68, 105, 115, 107, 73, 110, 2, 0, 4, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, -1, -1, 0, 3, 2, 0, 0 ]
#     end
#     it_should_behave_like "DiskIn"
#   end

#   describe VDiskIn, "two channels" do
#     before do
#       @channels = 2
#       @inputs   = 1, 2, 3, 4
#       @class    = VDiskIn
#       @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 105, 110, 0, 4, 63, -128, 0, 0, 64, 0, 0, 0, 64, 64, 0, 0, 64, -128, 0, 0, 0, 0, 0, 0, 0, 1, 7, 86, 68, 105, 115, 107, 73, 110, 2, 0, 4, 0, 2, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, -1, -1, 0, 3, 2, 2, 0, 0 ]
#     end
#     it_should_behave_like "DiskIn"
#   end

# end
