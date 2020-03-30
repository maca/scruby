require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    class Error < StandardError; end

    include OSC
    include Sclang::Helpers
    include PrettyInspectable
    include Encode
    include Concurrent

    attr_reader :host, :port, :client, :message_queue, :process,
                :client_id, :max_logins

    private :message_queue, :process


    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @client = OSC::Client.new(port, host)
      @message_queue = MessageQueue.new(self)
    end

    def boot(binary: "scsynth", **opts)
      raise Error, "already running" if alive?

      opts = Options.new(**opts, **{ bind_address: host, port: port })
      @process = Process.spawn(binary, opts.flags, env: opts.env)

      wait_for_booted
        .then_flat_future { message_queue.sync }
        .then { create_root_group }
        .then_flat_future { get_client_id }
        .then { self }
    end

    def alive?
      process&.alive? && message_queue.alive? || false
    end
    alias running? alive?

    def boot!(binary: "scsynth", **opts)
      boot(binary: binary, **opts).value!
    end

    def quit
      send_msg "/quit"
      # process.kill
    end

    def reboot
      quit
      message_queue.sync.then { boot }
    end

    def free_all
      send_msg "/g_freeAll", 0
      send_msg "/clearSched"
      send_msg "/g_new", 1, 0, 0
    end

    # def mute
    #   forward_async :mute
    # end

    # def unmute
    #   forward_async :unmute
    # end

    def dump_osc(code = 1)
      send_msg "/dumpOSC", code
    end

    def status
      message_queue.status.value!
    end

    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send_msg(message, *args)
      case message
      when Message, Bundle
        client.send(message)
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

    def receive(address, timeout: nil, &pred)
      message_queue.receive(address, timeout: timeout, &pred)
    end

    private

    def create_root_group
      send_msg("/g_new", 1, 0, 0)
    end

    def get_client_id
      send_msg("/notify", 1, client_id || 0)

      receive("/done", timeout: 0.5)
        .then { |msg| _, @client_id, @max_logins = msg.args }
    end

    def graph_completion_blob(message)
      return message || 0 unless message.is_a? Message
      Blob.new(message.encode)
    end

    def wait_for_booted
      Promises.future(Cancellation.timeout(5)) do |cancel|
        loop do
          cancel.check!
          line = process.read

          if /Address already in use/ === line
            raise Error, "Address in Use"
          end

          break cancel if /server ready/ === line
        end

        cancel
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
