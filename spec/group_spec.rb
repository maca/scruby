# frozen_string_literal: true

require File.join(__dir__, "server")


include Scruby
class Bus; end # mock

RSpec.describe Group do
  before :all do
  end

  before do
    Node.reset!
    allow(Server).to receive(:all).and_return([ @server ])
  end

  describe "Server interaction" do
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

    describe "position" do
    end

    it "should send free all message" do
      expect(@group.free_all).to be_a(Group)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/g_freeAll", #{ @group.id } \]})
    end

    it "should send deepFree message" do
      expect(@group.deep_free).to be_a(Group)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/g_deepFree", #{ @group.id } \]})
    end

    it "should send dump tree message" do
      expect(@group.dump_tree).to be_a(Group)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/g_dumpTree", #{ @group.id }, 0 \]})
      @group.dump_tree true
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/g_dumpTree", #{ @group.id }, 1 \]})
    end

    it "should send dump tree message with arg"
    it "should query_tree"
  end

end
