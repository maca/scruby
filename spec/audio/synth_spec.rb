require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require 'osc'
require "scruby/core_ext/typed_array" 
require "scruby/audio/node"
require "scruby/audio/group"
require "scruby/audio/synth"
require "scruby/audio/server"
require File.join( File.expand_path(File.dirname(__FILE__)), "server")


include Scruby
include Audio

describe Synth do
  
  before :all do
  end
  
  before do
    Node.reset!
    @target = Node.new( (0..3).map{ Server.new } )
    @synth  = Synth.new :synth, {:attack => 10}, @target
  end

  it "should initialize" do
    @synth.name.should    == 'synth'
    @synth.servers.should == @target.servers
  end
 
  it "should initialize not passing servers and have default servers" do
    s = Synth.new( 'synth' )
    s.servers.should == Server.all
  end
  
  describe 'Server interaction' do
    before :all do
      Server.clear
      @server = Server.new
      @server.boot
      @server.send "/dumpOSC", 3
      sleep 0.05
    end
    
    after :all do
      @server.quit
    end
    
    before do
      @server.flush
      @synth = Synth.new :synth, :attack => 10
    end
  
    it "should send /s_new message" do
      sleep 0.05
      @server.output.should =~ %r{\[ "/s_new", "#{ @synth.name }", #{ @synth.id }, 0, 1, "attack", 10 \]}
    end
  
    it "should send set message and return self" do
      @synth.set( :attack => 20 ).should == @synth
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_set", #{ @synth.id }, "attack", 20 \]}
    end
  end
  
end