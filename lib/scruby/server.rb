require "ruby-osc"
require "concurrent-edge"
require "forwardable"


module Scruby
  class Server
    class ServerError < StandardError; end
    class ClientInfo < Struct.new(:id, :max_logins); end

    extend Forwardable

    include OSC
    include Sclang::Helpers
    include PrettyInspectable
    include Encode
    include Concurrent

    attr_reader :osc_client, :message_queue, :process, :options,
                :client_info
    private :message_queue, :process

    def_delegators :options, :host, :port, :num_buffers


    def initialize(host: "127.0.0.1", port: 57_110, **options)
      @osc_client = OSC::Client.new(port, host)
      @message_queue = MessageQueue.new(self)
      @options = Options.new(**options, bind_address: host, port: port)
      @nodes = Nodes.new(self)
    end

    def alive?
      process_alive?
    end
    alias running? alive?

    def client_id
      client_info&.id
    end

    def max_logins
      client_info&.max_logins
    end

    def nodes
      @nodes.any? ? @nodes : update_nodes.value!
    end

    def node(idx)
      nodes[idx]
    end

    def add_node(node)
      nodes.add(node)
    end

    def next_node_id
      node_counter.increment
    end

    def next_buffer_id
      buffer_counter.increment
    end

    def boot(binary: "scsynth", **opts)
      boot_async(binary: binary, **opts).value!
    end

    def boot_async(binary: "scsynth", **opts)
      return sync.then { self } if process_alive?

      @options = Options.new(**options, **opts)
      @num_buffers = options.num_buffers
      @process = Process.spawn(binary, options.flags, env: options.env)

      wait_for_booted
        .then_flat_future { message_queue.sync }
        .then_flat_future { register_client }
        .then { create_root_group }
        .then { self }
        .on_rejection { process.kill }
    end

    def quit
      quit_async.value!
    end
    alias stop quit

    def quit_async
      # return Promises.fulfilled_future(self) unless alive?
      send_msg("/quit")

      receive { |msg| msg.to_a == %w(/done /quit) }
        .then { sleep 0.1 while process_alive? }
        .then { message_queue.flush }
        .then { @client_info = nil }
        .then { self }
    end
    alias stop_async quit_async

    def reboot
      reboot_async.value!
    end

    def reboot_async
      quit_async.then_flat_future { boot_async }
    end

    def free_all
      send_msg("/g_freeAll", 0)
      send_msg("/clearSched")
      create_root_group
    end

    # def mute
    #   forward_async :mute
    # end

    # def unmute
    #   forward_async :unmute
    # end

    def status
      status_async.value!
    end

    def status_async
      keys = %i(ugens synths groups synth_defs avg_cpu peak_cpu
          sample_rate actual_sample_rate)

      send_msg Message.new("/status")

      receive("/status.reply", timeout: 0.2)
        .then { |msg| keys.zip(msg.args[1..-1]).to_h }
    end

    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send_msg(message, *args)
      # Fix in ruby osc gem
      args = args.map { |a|
        case a
        when true then 1
        when false then 0
        else
          a
        end
      }

      case message
      when Message, Bundle
        osc_client.send(message)
      else
        osc_client.send Message.new(message, *args)
      end

      self
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

    def receive(address = nil, **args, &pred)
      message_queue.receive(address, **args, &pred)
    end

    def dump_server_messages(status = nil)
      return !!message_queue.debug if status.nil?
      message_queue.debug = !!status
    end

    def dump_osc(code = 1)
      send_msg("/dumpOSC", code)
    end

    def socket
      osc_client.instance_variable_get(:@socket)
    end

    private

    def process_alive?
      process&.alive? || false
    end

    def sync
      message_queue.sync
    end

    def update_nodes
      send_msg("/g_queryTree", 0, 1)

      receive("/g_queryTree.reply")
        .then { |msg| @nodes.decode_and_update(msg.args) }
    end

    def nodes_changed
      nodes.clear
      listen_node_changes
    end

    def listen_node_changes
      receive(Regexp.union(*ServerNode::MESSAGES), timeout: nil)
        .then_flat_future { nodes_changed }

      receive("/fail", timeout: nil) { |m|
        ServerNode::MESSAGES.include?(m.args.first)
      }.then_flat_future { nodes_changed }
    end

    def node_counter
      # client id is 5 bits and node id is 26 bits long
      # TODO: no specs
      @node_counter ||= AtomicFixnum.new((client_id << 26) + 1)
    end

    def buffer_counter
      # TODO: no specs
      @buffer_counter ||=
        AtomicFixnum.new((num_buffers / max_logins) * client_id)
    end

    def create_root_group
      send_msg("/g_new", 1, 0, 0)
    end

    def register_client
      send_msg("/notify", 1, 0)

      receive("/done")
        .then { |m| m.args.slice(1, 2) }
        .then { |a| a.each { |v| raise ServerError, v if String === v } }
        .then { |args| @client_info = ClientInfo.new(*args) }
        .then { listen_node_changes }
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
            raise ServerError, "could not open port"
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
    end
  end
end
