module Scruby
  class Synth
    include ServerNode

    def initialize(name, server, **params)
      super(server, Properties.new(name, **params))
    end

    def creation_message(action = :head, target = server.node(1))
      action_i = map_action(action)
      args = params.flatten

      OSC::Message.new(creation_cmd, name, id, action_i, target.id, *args)
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
      super(name: name, id: id)
    end

    private

    def creation_cmd; "/s_new" end

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
