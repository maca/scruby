require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require 'arguments'
require 'tempfile'
require 'osc'
require 'scruby/audio/node'
require 'scruby/core_ext/array'
require 'scruby/core_ext/typed_array'
require 'scruby/audio/buffer'
require "scruby/audio/server"


include Scruby
include Audio

Thread.abort_on_exception = true

class Scruby::Audio::Server
  attr_reader :output
  
  def puts string
    @output ||= ""
    @output << string
    string
  end
end

describe Message do
  it "should encode array as Message Blob" do
    m = Message.new "/b_allocRead", 1, "path", 1, -1, ["/b_query", 1]
    p m.encode
  end
end

describe Server do
  
  describe "booting" do
    before do
      @server = Server.new
    end

    after do
      @server.quit
    end

    it "should not rise scynth not found error" do
      lambda{ @server.boot }.should_not raise_error(Server::SCError)
    end

    it "should not reboot" do
      @server.boot
      Thread.should_not_receive(:new)
      @server.boot
    end

    it "should raise scsynth not found error" do
      lambda{ @server = Server.new(:path => '/not_scsynth'); @server.boot }.should raise_error(Server::SCError)
    end

    it "should add self to a list of servers" do
      s = Server.new
      Server.all.should include(s)
    end
  end

  describe 'sending OSC' do
    before :all do
      @server = Server.new
      @server.boot
      2.times do # ???
        @server.send "/status"
        sleep 0.2
        @server.send "/dumpOSC", 1
      end
    end
    
    after :all do
      @server.quit
    end
    
    it "should send dump" do
      @server.send "/dumpOSC", 1
      sleep 0.1
      @server.output.should =~ %r{/dumpOSC}
    end
    
    it "should send synthdef" do
      sdef = mock 'sdef', :encode => [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 0, 0 ].pack('C*')
      @server.send_synth_def sdef
      sleep 0.1
      @server.output.should =~ %r{\[ "#bundle", 1, \n\s*\[ "/d_recv", DATA\[56\], 0 \]\n\]}
    end
  end

end 

