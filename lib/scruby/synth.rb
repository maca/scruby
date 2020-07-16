module Scruby
  class Synth
    include ServerNode

    def get
    end

    def get_n
    end

    def inspect
      super(**{ name: name, id: id }.compact)
    end

    def create(action, target, name, **params)
      super(name, id, map_action(action), target.id, *params.flatten)
    end

    def creation_message(action, target, name, **params)
      super(name, id, map_action(action), target.id, *params.flatten)
    end

    private

    def creation_cmd; "/s_new" end

    class << self
      def create(name, server, **args)
        new(server).create(:head, server.node(1), name, **args)
      end

      def head(group, name, **args)
        new(group.server).create(:head, group, name, **args)
      end

      def tail(group, name, **args)
        new(group.server).create(:tail, group, name, **args)
      end

      def before(node, name, **args)
        new(node.server).create(:before, node, name, **args)
      end

      def after(node, name, **args)
        new(node.server).create(:after, node, name, **args)
      end

      def replace(node, name, **args)
        new(node.server).create(:replace, node, name, **args)
      end
    end
  end
end
