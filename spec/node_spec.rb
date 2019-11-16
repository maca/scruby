include Scruby

RSpec.describe Node do
  before :all do
    @server = Server.new
  end

  before do
    Node.reset!
    allow(Server).to receive(:all).and_return([@server])
  end

  it "should have incremental uniq id" do
    10.times do |i|
      expect(Node.new.id).to eq(2001 + i)
    end
  end

  it "should reset" do
    expect(Node.new.id).to eq(2001)
  end

  describe "instantiation" do
    it "should not accept non servers" do
      expect{ Node.new(1, 2) }.to   raise_error(TypeError)
      expect{ Node.new([1, 2]) }.to raise_error(TypeError)
    end

    it "should accept a server and have a TypedArray of Servers" do
      n = Node.new @server
      expect(n.servers).to eq([@server])
    end

    it "should have default servers if no server is passed" do
      n = Node.new
      expect(n.servers).to eq([@server])
    end
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
      @node = Node.new @server
    end

    it "should send free" do
      @node.free
      expect(@node).not_to   be_running
      expect(@node.group).to be_nil
      expect(@node).not_to   be_playing
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_free", #{ @node.id } \]})
    end

    it "should send run" do
      @node.run
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_run", #{ @node.id }, 1 \]})
      @node.run false
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_run", #{ @node.id }, 0 \]})
    end

    it "should send run" do
      @node.run
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_run", #{ @node.id }, 1 \]})
      @node.run false
      sleep 0.05
      expect(@server.output).to match(%r{\[ "/n_run", #{ @node.id }, 0 \]})
    end

    describe "map" do
      it "should just accept instances of Bus" do
        b1 = double "Bus", index: 1, channels: 1, rate: :audio
        expect(b1).to receive(:kind_of?).and_return(false)
        expect { @node.map freq1: b1 }.to raise_error(ArgumentError)
      end

      it "should send map" do
        b1 = double "Bus", index: 1, channels: 1, rate: :control
        expect(b1).to receive(:kind_of?).and_return(true)
        b2 = double "Bus", index: 2, channels: 2, rate: :audio
        expect(b2).to receive(:kind_of?).and_return(true)
        expect(@node.map( freq1: b1, freq2: b2 )).to be_instance_of(Node)
        sleep 0.05
        expect(@server.output).to match(%r{\[ \"#bundle\", 1, \n    \[ \"/n_mapn\", #{ @node.id }, \"freq1\", #{ b1.index }, 1 \],\n    \[ \"/n_mapan\", #{ @node.id }, \"freq2\", #{ b2.index }, 2 \]\n\]})
      end
    end

  end

end
