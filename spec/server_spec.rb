require File.expand_path(File.dirname(__FILE__)) + "/helper"

require 'arguments'
require 'tempfile'
require 'osc-ruby'
require 'scruby/node'
require 'scruby/core_ext/array'
require 'scruby/core_ext/typed_array'
require 'scruby/bus'
require "scruby/server"

include Scruby

module Mocks
  class Bus; end
  class Buffer; end
end

Thread.abort_on_exception = true

class Scruby::Server
  attr_reader :output
  
  def puts string
    @output ||= ""
    @output << string
    string
  end

end

class Scruby::Buffer
  def == other
    self.class == other.class
  end
end

describe Message do
  it "should encode array as Message Blob" do
    m = Message.new "/b_allocRead", 1, "path", 1, -1, ["/b_query", 1]
    m.encode.should == "/b_allocRead\000\000\000\000,isiib\000\000\000\000\000\001path\000\000\000\000\000\000\000\001\377\377\377\377\000\000\000\024/b_query\000\000\000\000,i\000\000\000\000\000\001"
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
    
    it "should remove server from server list" do
      @server.boot
      @server.quit
      Server.all.should be_empty
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
      @server.send "/dumpOSC", 3
      sleep 0.05
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
  
  shared_examples_for 'allocator' do
    it "should allow less than @max_size elements" do
      @server.__send__( :allocate, @kind, (1..@allowed_elements).map{ @class.new } )
      @server.__send__(@kind).size.should == @max_size
    end

    it "should not allow more than @max_size elements" do
      lambda { @server.__send__( :allocate, @kind, (1..@max_size+1).map{ @class.new } ) }.should raise_error(SCError)
    end
    
    it "should try to allocate lowest nil slot" do
      @server.__send__(@kind).concat([nil, nil, @class.new, nil, nil, nil, @class.new])
      @server.__send__ :allocate, @kind, buffer = @class.new
      @server.__send__(@kind).index(buffer).should == @index_start
    end
    
    it "should allocate various elements in available contiguous indices" do
      @server.__send__(@kind).concat([nil, nil, @class.new, nil, nil, nil, @class.new])
      @server.__send__ :allocate, @kind, @class.new, @class.new, @class.new
      elements = @server.__send__(@kind)[@max_size-@allowed_elements..-1].compact
      elements.should have(5).elements
    end
    
    it "should allocate by appending various elements" do
      @server.__send__(@kind).concat([nil, nil, @class.new, nil, nil, nil, @class.new])
      @server.__send__ :allocate, @kind, @class.new, @class.new, @class.new, @class.new
      elements = @server.__send__(@kind)[@max_size-@allowed_elements..-1].compact
      elements.should have(6).elements
    end
    
    it "should not surpass the max buffer limit" do
      @server.__send__( :allocate, @kind, (1..@allowed_elements-2).map{ |i| @class.new if i % 2 == 0 } )
      lambda { @server.__send__ :allocate, @kind, @class.new, @class.new, @class.new }.should raise_error
    end
    
    it "should allocate by appending" do
      @server.__send__( :allocate, @kind, (1..@allowed_elements-3).map{ |i| @class.new if i % 2 == 0 } )
      @server.__send__ :allocate, @kind, @class.new, @class.new, @class.new
      @server.__send__(@kind).size.should == @max_size
    end
  end
  
  describe 'buffers allocation' do
    before do
      @server = Server.new
      @kind   = :buffers
      @class  = ::Mocks::Buffer
      @allowed_elements = @max_size = 1024
      @index_start = 0
    end
    it_should_behave_like 'allocator'
  end
  
  describe 'control_buses allocation' do
    before do
      @server = Server.new
      @kind   = :control_buses
      @class  = ::Mocks::Bus
      @allowed_elements = @max_size = 4096
      @index_start = 0
    end
    it_should_behave_like 'allocator'
  end
  
  describe 'audio_buses allocation' do
    before do
      @server = Server.new
      @kind   = :audio_buses
      @class  = ::Mocks::Bus
      @allowed_elements = 112
      @max_size = 128
      @index_start = 16
    end
    it_should_behave_like 'allocator'
  end
  
end 

