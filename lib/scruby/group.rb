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

    class << self
      def head(target)
        new(target.server).send(:send_create, 21, 0, target.group)
      end

      def tail(target)
        new(target.server).send(:send_create, 21, 1, target.group)
      end

      def before(target)
        new(target.server).send(:send_create, 21, 2, target)
      end

      def after(target)
        new(target.server).send(:send_create, 21, 3, target)
      end

      def replace(target)
        new(target.server).send(:send_create, 21, 4, target)
      end
    end
  end
end
