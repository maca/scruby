module Scruby
  class Synth
    include ServerNode::Proxy

    def initialize(name, server, id = nil, **params)
      @node = ServerNode.new(server, -1, name, **params)
      node.id = id || server.next_node_id
    end

    def creation_message(action = :head, target = Group.new(server, 1))
      action_i = map_action(action)
      args = node.params.flatten

      OSC::Message.new("/s_new", name, id, action_i, target.id, *args)
    end

    def get
    end

    def get_n
    end

    def print_name
      params = self.params.map { |k, v| [ k, v ].join(":") }.join(", ")
      [ super, name, params ].join(" - ")
    end

    def inspect
      super(name: name, id: id, server: server)
    end

    private

    class << self
      def create(name, server, **args)
        new(name, server, **args).create
      end

      def head(group, name, **args)
        new(name, group.server, **args).create(:head, group)
      end

      def tail(group, name, **args)
        new(name, group.server, **args).create(:tail, group)
      end

      def before(node, name, **args)
        new(name, node.server, **args).create(:before, node)
      end

      def after(node, name, **args)
        new(name, node.server, **args).create(:after, node)
      end

      def replace(node, name, **args)
        new(name, node.server, **args).create(:replace, node)
      end
    end
  end
end
