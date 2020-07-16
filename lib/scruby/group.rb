module Scruby
  class Group
    include ServerNode

    def node_to_head(other)
      other.move_to_head(self)
    end

    def node_to_tail(other)
      other.move_to_tail(self)
    end

    def free_all
      send_msg("/g_freeAll", id)
    end

    def deep_free
      send_msg("/g_deepFree", id)
    end

    def dump_tree
    end

    def query_tree
    end

    def create(action, target)
      super(id, map_action(action), target.id)
    end

    def creation_message(action, target)
      super(id, map_action(action), target.id)
    end

    # TODO: no specs
    def children
      server.nodes.children_for(node)
    end

    def inspect
      super(id: id)
    end

    private

    def creation_cmd; "/g_new" end

    class << self
      def create(server)
        new(server).create(:head, server.node(1))
      end

      def head(group)
        new(group.server).create(:head, group)
      end

      def tail(group)
        new(group.server).create(:tail, group)
      end

      def before(node)
        new(node.server).create(:before, node)
      end

      def after(node)
        new(node.server).create(:after, node)
      end

      def replace(node)
        new(node.server).create(:replace, node)
      end
    end
  end
end
