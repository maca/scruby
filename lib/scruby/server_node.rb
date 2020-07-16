require "concurrent-edge"

module Scruby
  module ServerNode
    include PrettyInspectable

    POS = %i(head tail before after replace)
    MESSAGES = %w(/n_run /n_go /n_off /n_on /n_end /n_move)

    attr_reader :server

    def initialize(server, id = nil)
      @server, @id = server, id
    end

    def id
      @id ||= server.next_node_id
    end

    def node
      server.nodes.node(id)
    end

    def group
      Group.new(server, node.parent.id) if node.parent
    end
    alias parent group

    # Stop node and free from parent group on the server. Once a node
    # is stopped, it cannot be restarted.
    def free
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


    def move_before(other)
      send_msg("/n_before", id, other.id)
    end

    def move_after(other)
      send_msg("/n_after", id, other.id)
    end

    def move_to_head(group)
      send_msg("/g_head", group.id, id)
    end

    def move_to_tail(group)
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
    end

    def register
    end

    def unregister
    end

    def create(*args)
      send_msg(creation_cmd, *args)
    end

    def creation_message(*args)
      OSC::Message.new(creation_cmd, *args)
    end

    def print_name
      "#{self.class.name.split('::').last} #{id}"
    end

    def print
      Graph::Print.print(self)
    end

    private

    def creation_cmd
      raise NotImplementedError
    end

    def map_action(action)
      POS.index(action) || action
    end

    def future
      @future ||= Promises.fulfilled_future(self)
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
