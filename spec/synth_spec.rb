require File.expand_path(File.dirname(__FILE__)) + "/helper"

require 'osc'
require "scruby/core_ext/typed_array" 
require "scruby/node"
require "scruby/bus"
require "scruby/group"
require "scruby/synth"
require "scruby/server"
require File.join( File.expand_path(File.dirname(__FILE__)), "server")

include Scruby

describe Synth do

  describe 'instantiation with node target' do
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
    end

    it "should send /s_new message" do
      synth = Synth.new :synth, :attack => 10
      sleep 0.05
      @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 0, 1, "attack", 10 \]}
    end

    it "should send set message and return self" do
      synth = Synth.new :synth, :attack => 10
      synth.set( :attack => 20 ).should be_a(Synth)
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_set", #{ synth.id }, "attack", 20 \]}
    end

    describe 'Default Group' do
      it "should send after message" do
        synth = Synth.after nil, :synth, :attack => 10
        synth.should be_a(Synth)
        sleep 0.05
        @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 3, 1, "attack", 10 \]}
      end

      it "should send before message" do
        synth = Synth.before nil, :synth, :attack => 10
        synth.should be_a(Synth)
        sleep 0.05
        @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 2, 1, "attack", 10 \]}
      end

      it "should send head message" do
        synth = Synth.head nil, :synth, :attack => 10
        synth.should be_a(Synth)
        sleep 0.05
        @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 0, 1, "attack", 10 \]}
      end

      it "should send tail message" do
        synth = Synth.tail nil, :synth, :attack => 10
        synth.should be_a(Synth)
        sleep 0.05
        @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 1, 1, "attack", 10 \]}
      end

      it "should send replace message" do
        synth = Synth.replace nil, :synth, :attack => 10
        synth.should be_a(Synth)
        sleep 0.05
        @server.output.should =~ %r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 4, 1, "attack", 10 \]}
      end
    end
  end

end