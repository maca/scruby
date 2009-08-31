require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/core_ext/typed_array" 
require "scruby/node"
require "scruby/bus"

require 'scruby/server'
require File.join( File.expand_path(File.dirname(__FILE__)), "server")

include Scruby

describe Node do  
  before :all do
    @server  = Server.new
  end
  
  before do
    Node.reset!
    Server.stub!(:all).and_return([@server])
  end
  
  it "should have incremental uniq id" do
    10.times do |i|
      Node.new.id.should  == 2001 + i
    end    
  end
  
  it "should reset" do
    Node.new.id.should == 2001
  end
  
  describe 'instantiation' do
    it "should not accept non servers" do
      lambda{ Node.new(1,2) }.should   raise_error(TypeError)
      lambda{ Node.new([1,2]) }.should raise_error(TypeError)
    end
    
    it "should accept a server and have a TypedArray of Servers" do
      n = Node.new @server
      n.servers.should == [@server]
    end
    
    it "should have default servers if no server is passed" do
      n = Node.new
      n.servers.should == [@server]
    end
  end
  
  describe 'Server interaction' do
    before :all do
      @server = Server.new
      @server.boot
      @server.send "/dumpOSC", 3
      sleep 0.05
    end
    
    after :all do
      @server.quit
    end
    
    before do
      @node = Node.new @server
    end
    
    it "should send free" do
      @node.free
      @node.should_not   be_running
      @node.group.should be_nil
      @node.should_not   be_playing
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_free", #{ @node.id } \]}
    end
    
    it "should send run" do
      @node.run
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_run", #{ @node.id }, 1 \]}
      @node.run false
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_run", #{ @node.id }, 0 \]}
    end
    
    it "should send run" do
      @node.run
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_run", #{ @node.id }, 1 \]}
      @node.run false
      sleep 0.05
      @server.output.should =~ %r{\[ "/n_run", #{ @node.id }, 0 \]}
    end
    
    describe 'map' do
      it "should just accept instances of Bus" do
         b1 = mock 'Bus', :index => 1, :channels => 1, :rate => :audio
         b1.should_receive(:kind_of?).and_return(false)
         lambda { @node.map :freq1 => b1 }.should raise_error(ArgumentError)
      end
      
      it "should send map" do
        b1 = mock 'Bus', :index => 1, :channels => 1, :rate => :control
        b1.should_receive(:kind_of?).and_return(true)
        b2 = mock 'Bus', :index => 2, :channels => 2, :rate => :audio
        b2.should_receive(:kind_of?).and_return(true)
        @node.map( :freq1 => b1, :freq2 => b2 ).should be_instance_of(Node)
        sleep 0.05
        @server.output.should =~ %r{\[ \"#bundle\", 1, \n    \[ \"/n_mapn\", #{ @node.id }, \"freq1\", #{ b1.index }, 1 \],\n    \[ \"/n_mapan\", #{ @node.id }, \"freq2\", #{ b2.index }, 2 \]\n\]}
      end
    end
  
  end
  
end