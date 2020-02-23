require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    include OSC

    attr_reader :host, :port, :client, :message_queue, :process, :name
    private :process

    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @message_queue = MessageQueue.new(self)
      @client = OSC::Client.new(port, host)
      @name = "scruby_server_#{object_id}"
    end

    def boot(**opts)
      options = Options.new(**opts, **{ port: port })

      sclang_boot = <<-SC
        { var addr = NetAddr.new("#{options.address}", #{options.port});
          ~#{name} = Server.new("#{name}", addr);
          ~#{name}.boot;
        }.value
      SC

      Sclang.main.spawn
        .then { |lang| lang.eval_async(sclang_boot) }.flat_future
        .then { message_queue.sync }.flat_future
        .then { self }
    end

    def dump_osc(code = 1)
      send("/dumpOSC", code)
    end


    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send(message, *args)
      unless OSC::Message === message or OSC::Bundle === message
        message = OSC::Message.new(message, *args)
      end

      client.send message
    end

    def send_bundle(timestamp = nil, *messages)
      bundle = messages.map{ |message| OSC::Message.new(*message) }
      send OSC::Bundle.new(timestamp, *bundle)
    end

    # Encodes and sends a SynthDef to the scsynth server
    def send_synth_def(synth_def)
      message =
        OSC::Message.new("/d_recv", OSC::Blob.new(synth_def.encode), 0)

      send OSC::Bundle.new(nil, message)
    end
  end
end
