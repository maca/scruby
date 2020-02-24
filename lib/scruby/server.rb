require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    include OSC
    include Sclang::Helpers

    attr_reader :host, :port, :client, :message_queue, :process, :name
    private :process

    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @message_queue = MessageQueue.new(self)
      @client = Client.new(port, host)
      @name = "scruby_server_#{object_id}"
    end

    def boot(**opts)
      Sclang.main.spawn
        .then { |lang| eval_boot(opts, lang) }.flat_future
        .then { message_queue.sync }.flat_future
        .then { self }
    end

    def sclang_literal(value)
      case value
      when String, TrueClass, FalseClass, NilClass, Numeric
        value.inspect
      when Symbol
        "'#{value}'"
      else
        raise(ArgumentError,
              "#{value.inspect} is not of a valid server option type")
      end
    end

    def camelize(str)
      str.split("_").each_with_index
        .map { |s, i| i.zero? ? s : s.capitalize }.join
    end


    def dump_osc(code = 1)
      send("/dumpOSC", code)
    end


    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send(message, *args)
      case message
      when Message, Bundle then client.send(message)
      else
        client.send Message.new(message, *args)
      end
    end

    def send_bundle(*messages, timestamp: nil)
      bundle = messages.map{ |msg| Message.new(*msg) }
      send Bundle.new(timestamp, *bundle)
    end

    # Encodes and sends a SynthDef to the scsynth server
    def send_synth_def(graph)
      blob = Blob.new(graph)
      send Bundle.new(nil, Message.new("/d_recv", blob, 0))
    end


    private

    def eval_boot(opts, sclang)
      options = Options.new(**opts, **{ bind_address: host })

      opts_assigns = options.map do |k, v|
        "opts.#{camelize(k)} = #{literal(v)}"
      end

      sclang_boot = <<-SC
        { var addr = NetAddr.new("#{options.address}", #{port}),
              opts = ServerOptions.new;
          #{opts_assigns.join(";\n")};
          ~#{name} = Server.new("#{name}", addr);
          ~#{name}.boot;
        }.value
      SC

      sclang.eval_async(sclang_boot).then do |line|
        next line unless /error/i === line
        raise SclangError, "server could not be booted"
      end
    end
  end
end
