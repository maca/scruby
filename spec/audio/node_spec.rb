require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require "scruby/core_ext/typed_array" 
require "scruby/audio/node"
require 'osc'
require 'scruby/audio/server'

class Server; end
include Scruby

describe Node do  
  before :all do
    @server  = mock('server')
  end
  
  before do
    Node.reset!
    Server.stub!(:all).and_return([@server])
  end
  
  it "should have incremental uniq id" do
    10.times do |i|
      Node.new( 'nodo' ).id.should  == 2001 + i
    end    
  end
  
  it "should reset" do
    Node.new( 'nodo' ).id.should == 2001
  end
  
  describe 'instantiation' do
    
    it "should have a name" do
      Node.new('nodo').name.should == 'nodo'
    end
    
    it "should not accept non servers" do
      lambda{ Node.new('nodo', 1,2) }.should   raise_error(TypeError)
      lambda{ Node.new('nodo', [1,2]) }.should raise_error(TypeError)
    end
    
    it "should accept a server and have a TypedArray of Servers" do
      @server.should_receive(:instance_of?).exactly(:twice).and_return(true)
      n = Node.new( 'nodo', @server )
      n.servers.should == [@server]
      n = Node.new( 'nodo', [@server] )
      n.servers.should == [@server]
    end
    
    it "should have default servers if no server is passed" do
      n = Node.new( 'nodo' )
      n.servers.should == [@server]
    end
    
  end
  
end