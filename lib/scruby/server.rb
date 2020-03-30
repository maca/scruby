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
                :client_id

    private :message_queue, :process


    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @client = OSC::Client.new(port, host)
      @message_queue = MessageQueue.new(self)
    end

    def boot(binary: "scsynth", **opts)
      boot_async(binary: binary, **opts).value!
    end

    def boot_async(binary: "scsynth", **opts)
      if process_alive?
        return message_queue.sync.then { self }
      end

      opts = Options.new(**opts, **{ bind_address: host, port: port })
      @process = Process.spawn(binary, opts.flags, env: opts.env)

      wait_for_booted
        .then_flat_future { message_queue.sync }
        .then { client_id }
        .then { node_counter }
        .then { create_root_group }
        .then { self }
    end

    def alive?
      message_queue.alive?
    end
    alias running? alive?

    def process_alive?
      process&.alive? || false
    end

    def client_id
      @client_id ||= obtain_client_id.value!
    end

    def next_node_id
      node_counter.increment
    end

    def quit_async
      return Promises.fulfilled_future(self) unless alive?

      send_msg("/quit")

      receive(nil, timeout: 1) { |msg| msg.args == ["/quit"] }
        .then { sleep 0.5 while process_alive? }
        .then { message_queue.stop }
        .then { self }
    end

    def quit
      quit_async.value!
    end

    def reboot_async
      quit_async.then_flat_future { boot_async }
    end

    def reboot
      reboot_async.value!
    end

    def free_all
      send_msg "/g_freeAll", 0
      send_msg "/clearSched"
      create_root_group
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
      super(host: host, port: port, running: running?)
    end

    def receive(address, timeout: nil, &pred)
      message_queue.receive(address, timeout: timeout, &pred)
    end

    private

    def node_counter
      # client id is 5 bits and node id is 26 bits long
      @node_counter ||= Concurrent::AtomicFixnum.new(client_id << 26)
    end

    def create_root_group
      send_msg("/g_new", 1, 0, 0)
    end

    def obtain_client_id
      send_msg("/notify", 1, @client_id || 0)
      receive("/done", timeout: 0.5).then { |msg| msg.args[1] }
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
            raise Error, "could not open port"
          end

          break cancel if /server ready/ === line
        end

        cancel
      end
    end

    class << self
      attr_writer :default

      def boot(**args)
        new(**args).boot
      end

      def local
        Local.instance
      end

      def default
        @default || local
      end
    end
  end
end
