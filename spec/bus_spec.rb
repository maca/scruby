# include Scruby


# RSpec.describe Bus do
#   describe "instantiation" do
#     before do
#       @server  = Server.new
#       @audio   = Bus.audio   @server
#       @control = Bus.control @server
#     end

#     it "should be a bus" do
#       expect(@audio).to be_a(Bus)
#       expect(@control).to be_a(Bus)
#     end

#     it "should not instantiate with new" do
#       expect { Bus.new @server, :control, 1 }.to raise_error(NoMethodError)
#     end

#     it "should set server" do
#       expect(@audio.server).to eq(@server)
#     end

#     it "should set audio rate" do
#       expect(@audio.rate).to eq(:audio)
#     end

#     it "should set control rate" do
#       expect(Bus.control(@server).rate).to eq(:control)
#     end

#     it "should allocate in server on instantiation and have index" do
#       expect(@server.audio_buses).to include(@audio)
#       expect(@server.control_buses).to include(@control)
#     end

#     it "should have index" do
#       expect(@audio.index).to eq(16)
#       expect(@control.index).to eq(0)
#     end

#     it "should free and null index" do
#       @audio.free
#       expect(@server.audio_buses).not_to include(@audio)
#       expect(@audio.index).to.nil?
#       @control.free
#       expect(@server.audio_buses).not_to include(@control)
#       expect(@control.index).to.nil?
#     end

#     it "should return as map if control" do
#       expect(@control.to_map).to eq("c0")
#     end

#     it "should raise error if calling to_map on an audio bus" do
#       expect { @audio.to_map }.to raise_error(SCError)
#     end

#     it "should print usefull information with to_s"

#     it "should be hardware out" do
#       expect(@server.audio_buses[0]).to be_audio_out
#       expect(@audio).not_to be_audio_out
#     end

#     describe "multichannel" do
#       before do
#         @server   = Server.new
#         @audio    = Bus.audio   @server, 4
#         @control  = Bus.control @server, 4
#       end

#       it "should allocate consecutive when passing more than one channel for audio" do
#         expect(@audio.index).to eq(16)
#         buses = @server.audio_buses
#         expect(buses[16..-1].size).to eq(4)
#         expect(Bus.audio(@server).index).to eq(20)
#       end

#       it "should allocate consecutive when passing more than one channel for control" do
#         expect(@control.index).to eq(0)
#         expect(@server.control_buses.size).to eq(4)
#         expect(Bus.control(@server).index).to eq(4)
#       end

#       it "should set the number of channels" do
#         expect(@audio.channels).to   eq(4)
#         expect(@control.channels).to eq(4)
#       end

#       it "should depend on a main bus" do
#         expect(@server.audio_buses[16].main_bus).to  eq(@audio)   # main bus
#         expect(@server.audio_buses[17].main_bus).to  eq(@audio)   # main bus
#         expect(@server.control_buses[0].main_bus).to eq(@control) # main bus
#         expect(@server.control_buses[1].main_bus).to eq(@control) # main bus
#       end
#     end
#   end

#   describe "messaging" do
#     before :all do
#       @server = Server.new
#       @server.boot
#       @server.send "/dumpOSC", 3
#       @bus = Bus.control @server, 4
#       sleep 0.05
#     end

#     after :all do
#       @server.quit
#     end

#     before do
#       @server.flush
#     end

#     describe "set" do
#       it "should send set message with one value" do
#         @bus.set 101
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_set", #{ @bus.index }, 101 \]})
#       end

#       it "should accept value list and send set with them" do
#         @bus.set 101, 202
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202 \]})
#       end

#       it "should accept an array and send set with them" do
#         @bus.set [ 101, 202 ]
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202 \]})
#       end

#       it "should warn but not set if trying to set more values than channels" do
#         expect(@bus).to receive(:warn).with("You tried to set 5 values for bus #{ @bus.index } that only has 4 channels, extra values are ignored.")
#         @bus.set 101, 202, 303, 404, 505
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202, #{ @bus.index + 2}, 303, #{ @bus.index + 3}, 404 \]})
#       end
#     end

#     describe "set" do
#       it "should send fill just one channel" do
#         @bus.fill 101, 1
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_fill", #{ @bus.index }, 1, 101 \]})
#       end

#       it "should fill all channels" do
#         @bus.fill 101
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_fill", #{ @bus.index }, 4, 101 \]})
#       end

#       it "should raise error if trying to fill more than assigned channels" do
#         expect(@bus).to receive(:warn).with("You tried to set 5 values for bus #{ @bus.index } that only has 4 channels, extra values are ignored.")
#         @bus.fill 101, 5
#         sleep 0.01
#         expect(@server.output).to match(%r{\[ "/c_fill", #{ @bus.index }, 4, 101 \]})
#       end
#     end

#     describe "get" do
#       it "should send get message with one value"
#       it "should send get message for various channels"
#       it "should accept an array and send set with them"
#       it "should raise error if trying to set more values than channels"
#       it "should actually get the response from the server"
#     end

#   end
# end
