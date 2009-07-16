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
  describe '#server buffer allocation' do
    before do
      @server = Server.new
    end

    it "should register itself in server" do
      buffer = Buffer.new @server
      @server.buffers.should include(buffer)
    end

    it "should allow less than 1024 buffers" do
      @server.allocate_buffers( (1..1024).map{ mock(Buffer) } )
      @server.buffers.size.should == 1024
    end

    it "should not allow more than 1024 buffers" do
      lambda { @server.allocate_buffers( (1..1025).map{ mock(Buffer) } ) }.should raise_error(SCError)
    end
  end

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

    it "should send /b_allocRead message" do
      buffer = Buffer.read @server, "sounds/a11wlk01-44_1.aiff"
      buffer.should be_a(Buffer)
      sleep 0.1
      @server.output.should =~ %r{\[ "/b_allocRead", 0, "sounds/a11wlk01-44_1.aiff", 0, -1, DATA\[20\] \]}
    end

  end

end