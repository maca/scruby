require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    include OSC
    include Sclang::Helpers
    include PrettyInspectable
    include Encode

    attr_reader :host, :port, :client, :message_queue, :process, :name
    private :process


    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @message_queue = MessageQueue.new(self)
      @client = Client.new(port, host)
      @name = "~scruby_server_#{object_id}"
    end

    def boot(**opts)
      Sclang.main.spawn
        .then { eval_boot(opts) }.flat_future
        .then { message_queue.sync }.flat_future
        .then { self }
    end

    def boot!(**opts)
      boot(**opts).value!
    end

    def quit
      forward_async :quit
    end

    def reboot
      forward_async :reboot
    end

    def free_all
      forward_async :freeAll
    end

    def mute
      forward_async :mute
    end

    def unmute
      forward_async :unmute
    end

    def dump_osc(code = 1)
      send_msg("/dumpOSC", code)
    end

    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send_msg(message, *args)
      case message
      when Message, Bundle then client.send(message)
      else
        client.send Message.new(message, *args)
      end
    end

    def send_bundle(*messages, timestamp: nil)
      bundle = messages.map do |msg|
        msg.is_a?(Message) ? msg : Message.new(*msg)
      end

      send_msg Bundle.new(timestamp, *bundle)
    end

    # Encodes and sends a synth graph to the scsynth server
    def send_graph(graph, completion_message = nil)
      blob = Blob.new(graph.encode)
      on_completion = graph_completion_blob(completion_message)

      send_bundle Message.new("/d_recv", blob, on_completion)
    end

    def inspect
      super(host: host, port: port)
    end

    private

    def graph_completion_blob(message)
      return message || 0 unless message.is_a? Message
      Blob.new(message.encode)
    end

    def eval_async(code)
      Sclang.main.eval_async(code)
    end

    def forward_async(method)
      eval_async "#{name}.#{Sclang::Helpers.camelize(method.to_s)}"
    end

    def eval_boot(opts)
      options = Options.new(**opts, **{ bind_address: host })

      opts_assigns = options.map do |k, v|
        "opts.#{camelize(k)} = #{literal(v)}"
      end


      sclang_boot = <<-SC
        { var addr = NetAddr.new("#{options.address}", #{port}),
              opts = ServerOptions.new;
          #{opts_assigns.join(";\n")};
          #{name} = Server.new("#{name}", addr, opts);
          #{name}.boot;
        }.value
      SC

      eval_async(sclang_boot).then do |line|
        next line unless /error/i === line
        raise SclangError, "server could not be booted"
      end
    end

    class << self
      attr_writer :default

      def local
        Local.instance
      end

      def default
        @default || local
      end
    end
  end
end
