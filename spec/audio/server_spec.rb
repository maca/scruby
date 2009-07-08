require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require 'tempfile'
require 'osc'
require "scruby/audio/server"

include Scruby
include Audio


describe Server, 'instantiation and booting' do

  before do
    @server = Server.new
  end

  it "should not rise scynth not found error" do
    File.stub!( :exists ).and_return( true )
    lambda{ @server = Server.new; @server.boot; @server.stop }.should_not raise_error(Server::SCError)
  end

  it "should not reboot" do
    @server.boot
    Thread.should_not_receive(:new)
    @server.boot
    @server.stop
  end

  it "should raise scsynth not found error" do
    Server.sc_path = '/Applications/SuperCollider/not_scsynth'
    lambda{ @server = Server.new; @server.boot }.should raise_error(Server::SCError)
  end

  it "should add self to a list of servers" do
    s = Server.new
    Server.all.should include(s)
  end

  describe 'sending OSC' do

    before :all do
      Server.sc_path = '/Applications/SuperCollider/scsynth'

      encoded = "SCgf\000\000\000\001\000\001\003out\000\002C\334\000\000\000\000\000\000\000\000\000\000\000\002\006SinOsc\002\000\002\000\001\000\000\377\377\000\000\377\377\000\001\002\003Out\002\000\002\000\000\000\000\377\377\000\001\000\000\000\000\000\000"
      @sdef   = mock('sdef', :encode => encoded)

      @server = Server.new
      # @server.boot
    end

    after do
      # @server.stop
    end

    it "should send message" # do
    #      @server.send_synth_def( @sdef )
    # 
    #      # blob = [OSC::Blob.new( @sdef.encode ), 0]
    #      
    #    end



  end
end 

