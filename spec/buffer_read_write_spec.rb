# include Scruby
# include Ugens


# class MockUgen < Ugen
#   class << self; public :new; end
# end


# RSpec.describe "Buffer Read Ugens" do
#   shared_examples_for "Buffer reader Ugen" do
#     before do
#       @proxies  = @class.send @method, *@params
#       @inputs ||= @params
#       @instance = @proxies.first.source
#     end

#     it "should output a DelegatorArray" do
#       expect(@proxies).to be_a(DelegatorArray)
#     end

#     it "should have correct rate" do
#       expect(@instance.rate).to eq(@rate)
#     end

#     it "should return an array of output proxies" do
#       expect(@proxies).to be_a(Array)
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
#   end

#   shared_examples_for "Buffer reader Ugen with control rate" do
#     before do
#       @method = :kr
#       @rate   = :control
#     end
#     it_should_behave_like "Buffer reader Ugen"
#   end

#   shared_examples_for "Buffer reader Ugen with audio rate" do
#     before do
#       @method = :ar
#       @rate   = :audio
#     end
#     it_should_behave_like "Buffer reader Ugen"

#     it "should just accept audio inputs if rate is audio" # do
#     #      lambda { @class.new( :audio, MockUgen.new(:control) ) }.should raise_error(ArgumentError)
#     #    end
#   end

#   describe PlayBuf, "Two channel" do
#     before do
#       @class    = PlayBuf
#       @channels = 2
#       @inputs   = 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with control rate"
#     it_should_behave_like "Buffer reader Ugen with audio rate"
#   end

#   describe PlayBuf, "Four channel" do
#     before do
#       @class    = PlayBuf
#       @channels = 4
#       @inputs   = 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with control rate"
#     it_should_behave_like "Buffer reader Ugen with audio rate"
#   end

#   describe TGrains, "Two Channel" do
#     before do
#       @class    = TGrains
#       @channels = 2
#       @inputs   = 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with audio rate"

#     it "should require at least two channels" do
#       expect { @class.ar 1, *@params[1..-1] }.to raise_error(ArgumentError)
#     end
#   end

#   describe TGrains, "Four Channel" do
#     before do
#       @class    = TGrains
#       @channels = 4
#       @inputs   = 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with audio rate"

#     it "should require at least two channels" do
#       expect { @class.ar 1, *@params[1..-1] }.to raise_error(ArgumentError)
#     end
#   end

#   describe BufRd, "Two channel" do
#     before do
#       @class    = BufRd
#       @channels = 2
#       @inputs   = 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with control rate"
#     it_should_behave_like "Buffer reader Ugen with audio rate"

#     it "should require audio rate for phase"
#   end

#   describe BufRd, "Four channel" do
#     before do
#       @class    = BufRd
#       @channels = 4
#       @inputs   = 1.0, 1.0, 1.0, 1.0
#       @params   = @channels, *@inputs
#     end

#     it_should_behave_like "Buffer reader Ugen with control rate"
#     it_should_behave_like "Buffer reader Ugen with audio rate"
#   end
# end


# RSpec.describe "Buffer write Ugens" do
#   shared_examples_for "Buffer writter Ugen" do
#     before do
#       @buff_ugen = @class.send @method, *@params
#     end

#     it "should have correct rate" do
#       expect(@buff_ugen.rate).to eq(@rate)
#     end

#     it "should set inputs" do
#       expect(@buff_ugen.inputs).to eq(@inputs)
#     end
#   end

#   shared_examples_for "Buffer writter Ugen with control rate" do
#     before do
#       @rate   = :control
#       @method = :kr
#     end
#     it_should_behave_like "Buffer writter Ugen"
#   end

#   shared_examples_for "Buffer writter Ugen with audio rate" do
#     before do
#       @rate   = :audio
#       @method = :ar
#     end
#     it_should_behave_like "Buffer writter Ugen"
#   end

#   describe BufWr, "array input" do
#     before do
#       @class  = BufWr
#       @array  = [ MockUgen.new(:audio, 1, 2) ] * 4
#       @inputs = 1, 2, 3, *@array
#       @params = @array, 1, 2, 3
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe BufWr, "single input" do
#     before do
#       @class  = BufWr
#       @array  = MockUgen.new(:audio, 1, 2)
#       @inputs = 1, 2, 3, @array
#       @params = @array, 1, 2, 3
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe RecordBuf, "array input" do
#     before do
#       @class  = RecordBuf
#       @array  = [ MockUgen.new(:audio, 1, 2) ] * 4
#       @inputs = 1, 2, 3, 4, 5, 6, 7, 8, *@array
#       @params = @array, 1, 2, 3, 4, 5, 6, 7, 8
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe RecordBuf, "single input" do
#     before do
#       @class  = RecordBuf
#       @array  = MockUgen.new(:audio, 1, 2)
#       @inputs = 1, 2, 3, 4, 5, 6, 7, 8, @array
#       @params = @array, 1, 2, 3, 4, 5, 6, 7, 8
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe ScopeOut, "array input" do
#     before do
#       @class  = ScopeOut
#       @array  = [ MockUgen.new(:audio, 1, 2) ] * 4
#       @inputs = 1, *@array
#       @params = @array, 1
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe ScopeOut, "single input" do
#     before do
#       @class  = ScopeOut
#       @array  = MockUgen.new(:audio, 1, 2)
#       @inputs = 1, @array
#       @params = @array, 1
#     end
#     it_should_behave_like "Buffer writter Ugen with audio rate"
#     it_should_behave_like "Buffer writter Ugen with control rate"

#     it "should require phase to be audio rate"
#   end

#   describe Tap, "single input" do
#     before do
#       @inputs    = 5, 1, 0, SampleRate.ir.neg * 3, 1, 0
#       @buff_ugen = Tap.ar(5, 2, 3).first.source
#     end

#     it "should be instance of PlayBuf" do
#       expect(@buff_ugen).to be_a(PlayBuf)
#     end

#     it "should have correct rate" do
#       expect(@buff_ugen.rate).to eq(:audio)
#     end

#     it "should set inputs" do
#       expect(@buff_ugen.inputs).to eq(@inputs)
#     end
#   end

#   describe Tap, "single input" do
#     before do
#       @inputs    = 5, 1, 0, SampleRate.ir.neg * 3, 1, 0
#       @channels  = 1
#       @proxies   = Tap.ar(5, @channels, 3)
#     end

#     it "should have one proxy" do
#       expect(@proxies.size).to eq(@channels)
#     end

#     it "should be instance of PlayBuf" do
#       @proxies.each{ |p| expect(p.source).to be_a(PlayBuf) }
#     end

#     it "should have correct rate" do
#       @proxies.each{ |p| expect(p.source.rate).to eq(:audio) }
#     end

#     it "should set inputs" do
#       @proxies.each{ |p| p.source.inputs == @inputs }
#     end
#   end

#   describe Tap, "multi input" do
#     before do
#       @inputs    = 5, 1, 0, SampleRate.ir.neg * 3, 1, 0
#       @channels  = 4
#       @proxies   = Tap.ar(5, @channels, 3)
#     end

#     it "should have one proxy" do
#       expect(@proxies.size).to eq(@channels)
#     end

#     it "should be instance of PlayBuf" do
#       @proxies.each{ |p| expect(p.source).to be_a(PlayBuf) }
#     end

#     it "should have correct rate" do
#       @proxies.each{ |p| expect(p.source.rate).to eq(:audio) }
#     end

#     it "should set inputs" do
#       @proxies.each{ |p| p.source.inputs == @inputs }
#     end
#   end

#   # LocalBuf
#   # MaxLocalBufs
#   # ClearBuf
# end
