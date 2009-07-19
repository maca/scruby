require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require 'arguments'
require 'tempfile'
require 'osc'
require "scruby/audio/buffer"
require "scruby/audio/server"

include Scruby
include Audio

class Scruby::Audio::Server
  attr_reader :output
  def puts string
    @output ||= ""
    @output << string
    string
  end
end

describe Buffer do
  describe "messaging" do
    before :all do
      @server = Server.new
      @server.boot
      2.times do # ???
        @server.send "/status"
        sleep 0.2
        @server.send "/dumpOSC", 3
      end
    end
    
    after :all do
      @server.quit
    end
    
    describe 'Buffer.read' do
      before do
        @buffer = Buffer.read @server, "sounds/a11wlk01-44_1.aiff"
        sleep 0.1
      end
      
      it "should instantiate and send /b_allocRead message" do
        @buffer.should be_a(Buffer)
        @server.output.should =~ %r{\[ "/b_allocRead", #{ @buffer.buffnum }, "sounds/a11wlk01-44_1.aiff", 0, -1, DATA\[20\] \]}
        @server.output.should =~ /00 00 00 14  2f 62 5f 71  75 65 72 79  00 00 00 00/
      end
      
      it "should allow passing a completion message"
    end

    describe 'Buffer.allocate' do
      before do
        @buffer = Buffer.allocate @server, 44100 * 8.0, 2
        sleep 0.1
      end
      
      it "should call allocate and send /b_alloc message" do
        @buffer.should be_a(Buffer)
        @server.output.should =~ %r{\[ "/b_alloc", #{ @buffer.buffnum }, 352800, 2, 0 \]}
        @server.output.should =~ /69 00 00 00  00 00 00 00  00 44 ac 48  00 00 00 02/
      end
      
      it "should allow passing a completion message"
    end
  
    describe 'Buffer.cueSoundFile' do
      before do
        @buffer = Buffer.cue_sound_file @server, "sounds/a11wlk01-44_1.aiff", 0, 1
        sleep 0.1
      end
      
      it "should send /b_alloc message and instantiate" do
        @buffer.should be_a(Buffer)
        @server.output.should =~ %r{\[ "/b_alloc", #{ @buffer.buffnum }, 32768, 1, DATA\[72\] \]}
        @server.output.should =~ /64 73 2f 61  31 31 77 6c  6b 30 31 2d  34 34 5f 31/
        @server.output.should =~ /2e 61 69 66  66 00 00 00  00 00 00 00  00 00 80 00/
      end
      
      it "should allow passing a completion message"
    end
  
    describe '#free' do
      before do
        @buffer  = Buffer.allocate @server, 44100 * 10.0, 2
        @buffer2 = Buffer.allocate @server, 44100 * 10.0, 2
        @bnum    = @buffer2.buffnum
        @buffer2.free
        sleep 0.1
      end
      
      it "should remove itself from the server @buffers array and send free message" do
        @buffer2.buffnum.should be_nil
        @server.output.should =~ %r{\[ "/b_free", #{ @bnum }, 0 \]}
      end
      
      it "should allow passing a completion message"
      
    end
    
    describe 'Buffer.alloc_consecutive' do
      before do
        @buffers = Buffer.alloc_consecutive 8, @server, 4096, 2
        sleep 0.1
      end
      
      it "should send alloc message for each Buffer and instantiate" do
        @buffers.should have(8).buffers
        @buffers.each do |buff|
          @server.output.should =~ %r{\[ "/b_alloc", #{ buff.buffnum }, 4096, 2, 0 \]}
        end
      end
      
      it "should allow passing a message"
    end
    
    describe 'Buffer.read_channel' do
      before do
        @buffer = Buffer.read_channel @server, "sounds/SinedPink.aiff", :channels => [0]
        sleep 0.1
      end
      
      it "should allocate and send /b_allocReadChannel message" do
        @buffer.should be_a(Buffer)
        @server.output.should =~ %r{\[ "/b_allocReadChannel", #{ @buffer.buffnum }, "sounds/SinedPink.aiff", 0, -1, 0, DATA\[20\] \]}
        @server.output.should =~ /73 6f 75 6e  64 73 2f 53  69 6e 65 64  50 69 6e 6b/
      end
    end
  end
end