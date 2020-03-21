module Scruby
  class Group
    include Node

    def node_to_head(node)
      node.head(self)
    end

    def node_to_tail(node)
      node.tail(self)
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
      group_from_target(target, action)
      send_msg(creation_cmd, id, map_action(action), target.id)
    end

    def inspect
      super(id: id, server: server)
    end

    private

    def creation_cmd; "/g_new" end

    class << self
      def create(server)
        new(server).create(:head, Group.new(server, 1))
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
