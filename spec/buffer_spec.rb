# include Scruby


# RSpec.describe Buffer do
#   describe "messaging" do
#     before :all do
#       @server = Server.new
#       @server.boot
#       @server.send "/dumpOSC", 3
#       sleep 0.05
#     end

#     after :all do
#       @server.quit
#     end

#     describe "Buffer.read" do
#       before do
#         @buffer = Buffer.read @server, "sounds/a11wlk01-44_1.aiff"
#         sleep 0.005
#       end

#       it "should instantiate and send /b_allocRead message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_allocRead", #{ @buffer.buffnum }, "/.+/Scruby/sounds/a11wlk01-44_1.aiff", 0, -1, DATA\[20\] \]})
#       end

#       it "should allow passing a completion message"
#     end

#     describe "Buffer.allocate" do
#       before do
#         @buffer = Buffer.allocate @server, 44_100 * 8.0, 2
#         sleep 0.005
#       end

#       it "should call allocate and send /b_alloc message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_alloc", #{ @buffer.buffnum }, 352800, 2, 0 \]})
#         expect(@server.output).to match(/69 00 00 00  00 00 00 00  00 44 ac 48  00 00 00 02/)
#       end

#       it "should allow passing a completion message"
#     end

#     describe "Buffer.cueSoundFile" do
#       before do
#         @buffer = Buffer.cue_sound_file @server, "/sounds/a11wlk01-44_1.aiff", 0, 1
#         sleep 0.005
#       end

#       it "should send /b_alloc message and instantiate" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_alloc", #{ @buffer.buffnum }, 32768, 1, DATA\[72\] \]})
#         expect(@server.output).to match(/6e 64 73 2f  61 31 31 77  6c 6b 30 31  2d 34 34 5f/)
#       end

#       it "should allow passing a completion message"
#     end

#     describe "#free" do
#       before do
#         @buffer  = Buffer.allocate @server, 44_100 * 10.0, 2
#         @buffer2 = Buffer.allocate @server, 44_100 * 10.0, 2
#         @bnum    = @buffer2.buffnum
#         @buffer2.free
#         sleep 0.005
#       end

#       it "should remove itself from the server @buffers array and send free message" do
#         expect(@buffer2.buffnum).to be_nil
#         expect(@server.output).to match(%r{\[ "/b_free", #{ @bnum }, 0 \]})
#       end

#       it "should allow passing a completion message"

#     end

#     describe "Buffer.alloc_consecutive" do
#       before do
#         @buffers = Buffer.alloc_consecutive 8, @server, 4096, 2
#         sleep 0.005
#       end

#       it "should send alloc message for each Buffer and instantiate" do
#         expect(@buffers.size).to eq(8)
#         @buffers.each do |buff|
#           expect(@server.output).to match(%r{\[ "/b_alloc", #{ buff.buffnum }, 4096, 2, 0 \]})
#         end
#       end

#       it "should allow passing a message"
#     end

#     describe "Buffer.read_channel" do
#       before do
#         @buffer = Buffer.read_channel @server, "sounds/SinedPink.aiff", channels: [ 0 ]
#         sleep 0.005
#       end

#       it "should allocate and send /b_allocReadChannel message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_allocReadChannel", #{ @buffer.buffnum }, "/.+/Scruby/sounds/SinedPink.aiff", 0, -1, 0, DATA\[20\] \]})
#       end
#     end

#     describe "#read" do
#       before do
#         @buffer = Buffer.allocate(@server, 44_100 * 10.0, 2).read("sounds/robot.aiff")
#         sleep 0.005
#       end

#       it "should send message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_read", #{ @buffer.buffnum }, "/.+/Scruby/sounds/robot.aiff", 0, -1, 0, 0, DATA\[20\] \]})
#       end

#       it "should allow passing a completion message"
#     end

#     describe "#close" do
#       before do
#         @buffer = Buffer.read(@server, "sounds/a11wlk01-44_1.aiff").close
#         sleep 0.005
#       end

#       it "should send message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_close", #{ @buffer.buffnum }, 0 \]})
#       end

#       it "should allow passing a completion message"
#     end

#     describe "#zero" do
#       before do
#         @buffer = Buffer.read(@server, "sounds/a11wlk01-44_1.aiff").zero
#         sleep 0.005
#       end

#       it "should send message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_zero", #{ @buffer.buffnum }, 0 \]})
#       end

#       it "should allow passing a completion message"
#     end

#     describe "#cue_sound_file" do
#       before do
#         @buffer = Buffer.allocate(@server, 44_100, 2).cue_sound_file("sounds/robot.aiff")
#         sleep 0.005
#       end

#       it "should send message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_read", #{ @buffer.buffnum }, "/.+/Scruby/sounds/robot.aiff", 0, 44100, 0, 1, 0 \]})
#       end

#       it "should allow passing a completion message"
#     end

#     describe "#write" do
#       before do
#         @buffer = Buffer.allocate(@server, 44_100 * 10.0, 2).write(
#           "sounds/test.aiff", "aiff", "int16", 0, 0, true
#         )
#         sleep 0.005
#       end

#       it "should send message" do
#         expect(@buffer).to be_a(Buffer)
#         expect(@server.output).to match(%r{\[ "/b_write", #{ @buffer.buffnum }, "/.+/Scruby/sounds/test.aiff", "aiff", "int16", 0, 0, 1, 0 \]})
#       end

#       it "should have a default path" do
#         @server.flush
#         buffer = Buffer.allocate(@server, 44_100 * 10.0, 2).write(nil, "aiff", "int16", 0, 0, true)
#         sleep 0.005
#         expect(@server.output).to match(%r{\[ "/b_write", #{ buffer.buffnum }, "/.+/Scruby/\d\d\d\d.+\.aiff", "aiff", "int16", 0, 0, 1, 0 \]})
#       end

#       it "should allow passing a completion message"
#     end
#   end
# end
