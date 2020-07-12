require "concurrent-edge"

module Scruby
  module Node
    include Equatable
    include PrettyInspectable

    ACTIONS = %i(head tail before after replace)
    # MSGS = %w(/n_go /n_off /n_on /n_end)

    attr_reader :server, :id, :group
    attr_writer :group

    protected :group=

    def initialize(server, id = nil)
      @server = server
      @id = id || server.next_node_id
    end

    # Stop node and free from parent group on the server. Once a node
    # is stopped, it cannot be restarted.
    def free
      @group = nil
      send_msg("/n_free", id)
    end

    # Run node after it has been stoped.
    def run
      send_msg("/n_run", id, true)
    end

    # Stop node, the node can be resumed.
    def stop
      send_msg("/n_run", id, false)
    end

    def set(**args)
      send_msg("/n_set", id, *args.flatten)
    end

    def map(**args)
      msgs = args.group_by { |_, b| b.rate }.map(&method(:msg_for_map))
      send_bundle(*msgs.compact)
    end

    def release(time = nil)
      send_msg(15, id, :gate, release_time(time))
    end

    # Instructs the server to print out the values of the inputs and
    # outputs of its unit generators.
    def trace
      send_msg("/n_trace", id)
    end

    def move_before(node)
      @group = node.group
      send_msg("/n_before", id, node.id)
    end

    def move_after(node)
      @group = node.group
      send_msg("/n_after", id, node.id)
    end

    def move_to_head(group)
      @group = group
      send_msg("/g_head", group.id, id)
    end

    def move_to_tail(group)
      @group = group
      send_msg("/g_tail", group.id, id)
    end

    def fill
    end

    # Check if the node is running.
    # @return [Boolean]
    #
    # @example
    #   server = Server.boot
    #   node = SinOsc.ar.play(server)
    #   node.running? #=> true
    #   node.stop
    #   node.running? #=> false
    def running?
      query.fetch(:running)
    end

    # Send a *n_query* message to the server to obtain and return
    # information about the node.
    #
    # @return [Hash]
    #
    # @example
    #   server = Server.boot
    #   node = SinOsc.ar.play(server)
    #   node.query #=> { running: true, id: 3, parent: 1, ... }
    def query
      query_async.value!
    end

    # Async version of {query}.
    #
    # @return [Concurrent::Promises::Future]
    def query_async
      # no specs
      send_msg("/n_query", id)

      keys = %i(running id parent prev next head tail)

      success = receive("/n_info") { |m| m.args.first == id }
                  .then { |msg| Hash[ keys.zip([ true, *msg.args ]) ] }

      failure = receive("/fail") { |m|
        m.args.first == "/n_query" && m.args.last.include?(id.to_s)
      }.then { Hash[ keys.zip([ false, id ]) ] }

      Concurrent::Promises.any(success, failure)
    end

    def register
    end

    def unregister
    end

    def on_free
    end

    def wait_for_free
    end

    def print_name
      "#{self.class.name.split('::').last} #{id}"
    end

    def visualize
      Graph::Visualize.print self
    end

    def create(action = :head, target = Group.new(server, 1))
      @group = group_from_target(target, action)
      send_msg *creation_message(action, target)
    end

    private

    def creation_message(_, _)
      raise NotImplementedError
    end

    def map_action(action)
      ACTIONS.index(action) || action
    end

    def group_from_target(target, action)
      map_action(action) < 2 ? target : target.group
    end

    def send_msg(*args)
      server.send_msg(*args)
      self
    end

    def receive(*args)
      server.receive(*args)
    end

    def send_bundle(*args)
      server.send_bundle(*args)
      self
    end

    def send_create(msg, action, target)
      send_msg(msg, id, action, target.id)
    end

    def release_time(time = nil)
      return 0 if time.nil?
      return -1 if time < 1
      (time + 1) * -1
    end

    def msg_for_map(rate, params)
      args = params.map { |n, bus| [ n, bus.index, bus.channels ] }

      case rate
      when :control
        [ "/n_mapn", id, *args ].flatten
      when :audio
        [ "/n_mapan", id, *args ].flatten
      end
    end
  end
end
