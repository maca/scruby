module Scruby
  class Synth
    include Node

    attr_reader :name

    def initialize(name, server)
      @name = name
      super(server)
    end

    def create(action, target, **args)
      @group = action < 2 ? target : target.group
      send_msg('/s_new', name, id, action, target.id, *args.flatten)
    end

    private

    class << self
      def create(name, server, **args)
        new(name, server).create(0, Group.new(server, 1), **args)
      end

      def head(name, group, **args)
        new(name, group.server).create(0, group, **args)
      end

      def tail(name, group, **args)
        new(name, group.server).create(1, group, **args)
      end

      def before(name, node, **args)
        new(name, node.server).create(2, node, **args)
      end

      def after(name, node, **args)
        new(name, node.server).create(3, node, **args)
      end

      def replace(name, node, **args)
        new(name, node.server).create(4, node, **args)
      end
    end
  end
end
