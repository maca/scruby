module Scruby
  class Synth
    include Node

    attr_reader :name

    def initialize(name, server, id = nil)
      @name = name
      super(server, id)
    end

    def create(action, target, **args)
      @group = action < 2 ? target : target.group
      send_msg("/s_new", name, id, action, target.id, *args.flatten)
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
        new(name, server).create(0, Group.new(server, 1), **args)
      end

      def head(group, name, **args)
        new(name, group.server).create(0, group, **args)
      end

      def tail(group, name, **args)
        new(name, group.server).create(1, group, **args)
      end

      def before(node, name, **args)
        new(name, node.server).create(2, node, **args)
      end

      def after(node, name, **args)
        new(name, node.server).create(3, node, **args)
      end

      def replace(node, name, **args)
        new(name, node.server).create(4, node, **args)
      end
    end
  end
end
