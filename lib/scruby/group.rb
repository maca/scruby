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
      send_msg('/g_freeAll', id)
    end

    def deep_free
      send_msg('/g_deepFree', id)
    end

    def dump_tree
    end

    def query_tree
    end

    private

    def creation_cmd; 21 end

    class << self
      def create(server)
        new(server).create(0, Group.new(server, 1))
      end

      def head(target)
        new(target.server).create(0, target)
      end

      def tail(target)
        new(target.server).create(1, target)
      end

      def before(target)
        new(target.server).create(2, target)
      end

      def after(target)
        new(target.server).create(3, target)
      end

      def replace(target)
        new(target.server).create(4, target)
      end
    end
  end
end
