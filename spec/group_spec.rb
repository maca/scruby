require File.expand_path(File.dirname(__FILE__)) + "/helper"


require "scruby/core_ext/typed_array" 
require "scruby/node"
require "scruby/group"
require 'scruby/bus'

require 'scruby/server'
require File.join( File.expand_path(File.dirname(__FILE__)), "server")


include Scruby
class Bus; end # mock

describe Group do  
  before :all do
  end
  
  before do
    Node.reset!
    Server.stub!(:all).and_return([@server])
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
      @server.flush
      @group = Group.new @server
      @node  = Node.new @server
    end
    
    describe 'position' do
    end
    
    it "should send free all message" do
      @group.free_all.should be_a(Group)
      sleep 0.05
      @server.output.should =~ %r{\[ "/g_freeAll", #{ @group.id } \]}
    end
    
    it "should send deepFree message" do
      @group.deep_free.should be_a(Group)
      sleep 0.05
      @server.output.should =~ %r{\[ "/g_deepFree", #{ @group.id } \]}
    end
    
    it "should send dump tree message" do
      @group.dump_tree.should be_a(Group)
      sleep 0.05
      @server.output.should =~ %r{\[ "/g_dumpTree", #{ @group.id }, 0 \]}
      @group.dump_tree true
      sleep 0.05
      @server.output.should =~ %r{\[ "/g_dumpTree", #{ @group.id }, 1 \]}
    end
    
    it "should send dump tree message with arg"
    it "should query_tree"
  end
  
end