# frozen_string_literal: true

require File.join(__dir__, "server")

include Scruby

RSpec.describe Synth do

  before :all do
    Server.clear
    @server = Server.new
    @server.boot
    @server.send "/dumpOSC", 3
    sleep 0.05
  end

  after :all do
    @server.quit
    sleep 1
  end

  before do
    @server.flush
  end

  describe "instantiation with node target" do
    before do
      Node.reset!
      @target = Node.new((0..3).map{ Server.new })
      @synth  = Synth.new :synth, { attack: 10 }, @target
    end

    it "should initialize" do
      expect(@synth.name).to    eq("synth")
      expect(@synth.servers).to eq(@target.servers)
    end

    it "should initialize not passing servers and have default servers" do
      s = Synth.new("synth")
      expect(s.servers).to eq(Server.all)
    end
  end

  describe "instantiaton messaging" do
    it "should send /s_new message" do
      synth = Synth.new :synth, attack: 10
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 0, 1, "attack", 10 \]})
    end

    it "should send set message and return self" do
      synth = Synth.new :synth, attack: 10
      expect(synth.set(attack: 20)).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_set", #{ synth.id }, "attack", 20 \]})
    end
  end

  describe "Default Group" do
    it "should send after message" do
      synth = Synth.after nil, :synth, attack: 10
      expect(synth).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 3, 1, "attack", 10 \]})
    end

    it "should send before message" do
      synth = Synth.before nil, :synth, attack: 10
      expect(synth).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 2, 1, "attack", 10 \]})
    end

    it "should send head message" do
      synth = Synth.head nil, :synth, attack: 10
      expect(synth).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 0, 1, "attack", 10 \]})
    end

    it "should send tail message" do
      synth = Synth.tail nil, :synth, attack: 10
      expect(synth).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 1, 1, "attack", 10 \]})
    end

    it "should send replace message" do
      synth = Synth.replace nil, :synth, attack: 10
      expect(synth).to be_a(Synth)
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/s_new", "#{ synth.name }", #{ synth.id }, 4, 1, "attack", 10 \]})
    end
  end

end
