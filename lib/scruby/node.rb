require "concurrent-edge"

module Scruby
  module Node
    include Equatable
    include PrettyInspectable

    ACTIONS = %i(head tail before after replace)

    attr_reader :server, :id, :group

    def initialize(server, id = nil)
      @server = server
      @id = id || Node.next_id
    end

    def free
      @group = nil
      send_msg("/n_free", id)
    end

    def run
      send_msg("/n_run", id, true)
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

    def trace
      send_msg("/n_trace", id)
    end

    def before(node)
      @group = node.group
      send_msg("/n_before", id, node.id)
    end

    def after(node)
      @group = node.group
      send_msg("/n_after", id, node.id)
    end

    def head(group)
      @group = group
      send_msg("/g_head", group.id, id)
    end

    def tail(group)
      @group = group
      send_msg("/g_tail", group.id, id)
    end

    def fill
    end

    def query
    end

    def register
    end

    def unregister
    end

    def on_free
    end

    def wait_for_free
    end

    private

    def map_action(action)
      ACTIONS.index(action) || action
    end

    def group_from_target(target, action)
      @group = map_action(action) < 2 ? target : target.group
    end

    def send_msg(*args)
      server.send_msg(*args)
      self
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

    class << self
      def next_id
        (@next_id ||= Concurrent::AtomicFixnum.new(999)).increment
      end
    end
  end
end
