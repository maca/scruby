require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    include OSC
    include Sclang::Helpers
    include PrettyInspectable
    include Encode

    attr_reader :host, :port, :client, :message_queue, :process
    private :process


    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @message_queue = MessageQueue.new(self)
      @client = OSC::Client.new(port, host)
    end

    def boot(binary: "scsynth", **opts)
      options = Options.new(**opts, **{ bind_address: host })
      @process = Process.spawn(binary, options.flags, env: options.env)

      message_queue.sync
        .then { continue_boot }
        .then { self }
    end

    def boot!(binary: "scsynth", **opts)
      boot(binary: binary, **opts).value!
    end

    # def quit
    #   forward_async :quit
    # end

    # def reboot
    #   forward_async :reboot
    # end

    # def free_all
    #   forward_async :freeAll
    # end

    # def mute
    #   forward_async :mute
    # end

    # def unmute
    #   forward_async :unmute
    # end

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

    def continue_boot
      send_msg "/g_new", 1, 0, 0
    end

    def graph_completion_blob(message)
      return message || 0 unless message.is_a? Message
      Blob.new(message.encode)
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
