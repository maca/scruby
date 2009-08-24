require File.expand_path(File.dirname(__FILE__)) + "/helper"

require 'tempfile'
require 'osc-ruby'
require "scruby/core_ext/numeric"
require "scruby/bus"
require "scruby/server"
require File.join( File.expand_path(File.dirname(__FILE__)), "server")

include Scruby


describe Bus do
  describe 'instantiation' do
    before do
      @server  = Server.new
      @audio   = Bus.audio   @server
      @control = Bus.control @server
    end
    
    it "should be a bus" do
      @audio.should be_a(Bus)
      @control.should be_a(Bus)
    end
    
    it "should not instantiate with new" do
      lambda { Bus.new @server, :control, 1 }.should raise_error(NoMethodError)
    end
    
    it "should set server" do
      @audio.server.should == @server
    end
    
    it "should set audio rate" do
      @audio.rate.should == :audio
    end
    
    it "should set control rate" do
      Bus.control(@server).rate.should == :control
    end
    
    it "should allocate in server on instantiation and have index" do
      @server.audio_buses.should include(@audio)
      @server.control_buses.should include(@control)
    end
    
    it "should have index" do
      @audio.index.should == 16
      @control.index.should == 0
    end

    it "should free and null index" do
      @audio.free
      @server.audio_buses.should_not include(@audio)
      @audio.index.should == nil
      @control.free
      @server.audio_buses.should_not include(@control)
      @control.index.should == nil
    end
    
    it "should return as map if control" do
      @control.to_map.should == "c0"
    end
    
    it "should raise error if calling to_map on an audio bus" do
      lambda { @audio.to_map }.should raise_error(SCError)
    end
    
    it "should print usefull information with to_s"
    
    it "should be hardware out" do
      @server.audio_buses[0].should be_audio_out
      @audio.should_not be_audio_out
    end
    
    describe 'multichannel' do
      before do
        @server   = Server.new
        @audio    = Bus.audio   @server, 4
        @control  = Bus.control @server, 4
      end
      
      it "should allocate consecutive when passing more than one channel for audio" do
        @audio.index.should == 16
        buses = @server.audio_buses
        buses[16..-1].should have(4).elements
        Bus.audio(@server).index.should == 20
      end
      
      it "should allocate consecutive when passing more than one channel for control" do
        @control.index.should == 0
        @server.control_buses.should have(4).elements
        Bus.control(@server).index.should == 4
      end
      
      it "should set the number of channels" do
        @audio.channels.should   == 4
        @control.channels.should == 4
      end
      
      it "should depend on a main bus" do
        @server.audio_buses[16].main_bus.should  == @audio   #main bus
        @server.audio_buses[17].main_bus.should  == @audio   #main bus
        @server.control_buses[0].main_bus.should == @control #main bus
        @server.control_buses[1].main_bus.should == @control #main bus
      end
    end
  end
  
  describe "messaging" do
    before :all do
      @server = Server.new
      @server.boot
      @server.send "/dumpOSC", 3
      @bus = Bus.control @server, 4
      sleep 0.05
    end    

    after :all do
      @server.quit
    end
    
    before do
      @server.flush
    end
    
    describe 'set' do
      it "should send set message with one value" do
        @bus.set 101
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_set", #{ @bus.index }, 101 \]}
      end
      
      it "should accept value list and send set with them" do
        @bus.set 101, 202
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202 \]}
      end
      
      it "should accept an array and send set with them" do
        @bus.set [101, 202]
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202 \]}
      end
      
      it "should warn but not set if trying to set more values than channels" do
        @bus.should_receive(:warn).with("You tried to set 5 values for bus #{ @bus.index } that only has 4 channels, extra values are ignored.")
        @bus.set 101, 202, 303, 404, 505
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_set", #{ @bus.index }, 101, #{ @bus.index + 1}, 202, #{ @bus.index + 2}, 303, #{ @bus.index + 3}, 404 \]}
      end
    end
    
    describe 'set' do
      it "should send fill just one channel" do
        @bus.fill 101, 1
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_fill", #{ @bus.index }, 1, 101 \]}
      end
      
      it "should fill all channels" do
        @bus.fill 101
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_fill", #{ @bus.index }, 4, 101 \]}
      end
      
      it "should raise error if trying to fill more than assigned channels" do
        @bus.should_receive(:warn).with("You tried to set 5 values for bus #{ @bus.index } that only has 4 channels, extra values are ignored.")
        @bus.fill 101, 5
        sleep 0.01
        @server.output.should =~ %r{\[ "/c_fill", #{ @bus.index }, 4, 101 \]}
      end
    end
    
    describe 'get' do
      it "should send get message with one value"
      it "should send get message for various channels"
      it "should accept an array and send set with them"
      it "should raise error if trying to set more values than channels"
      it "should actually get the response from the server"
    end

  end
end