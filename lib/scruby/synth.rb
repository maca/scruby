module Scruby
  class Synth
    include Node
    include OSC

    attr_reader :name

    def initialize(name, server, id = nil)
      @name = name
      super(server, id)
    end

    def create(target, action = :head, **args)
      group_from_target(target, action)
      send_msg *creation_message(target, action, **args)
    end

    # TODO: no specs
    def creation_message(target, action = :head, **args)
      action_i = map_action(action)
      Message.new("/s_new", name, id, action_i, target.id, *args.flatten)
    end

    def get
    end

    def get_n
    end

    def inspect
      super(name: name, id: id, server: server)
    end

    class << self
      def create(server, name, **args)
        new(name, server).create(Group.new(server, 1), :head, **args)
      end

      def head(group, name, **args)
        new(name, group.server).create(group, :head, **args)
      end

      def tail(group, name, **args)
        new(name, group.server).create(group, :tail, **args)
      end

      def before(node, name, **args)
        new(name, node.server).create(node, :before, **args)
      end

      def after(node, name, **args)
        new(name, node.server).create(node, :after, **args)
      end

      def replace(node, name, **args)
        new(name, node.server).create(node, :replace, **args)
      end
    end
  end
end
