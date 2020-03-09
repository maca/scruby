module Scruby
  class Synth
    include Node

    attr_reader :name, :action, :server, :id

    def initialize(name, target = Server.default, action: :head, **args)
      @name = name
      @id = Node.next_id
      @target = target
      @action = action
      # @group = %i(head tail).include?(action) ? target : target.group

      send_new(**args)
    end

    private

    attr_reader :target

    def send_new(**args)
      server.send_msg("/s_new", name, id, action_id, target_id, **args)
    end

    class << self
      def after(node, name, **args)
        new name, node, action: :after, **args
      end

      def before(node, name, **args)
        new name, node, action: :before, **args
      end

      def head(group, name, **args)
        new name, group, action: :head, **args
      end

      def after(group, name, **args)
        new name, group, action: :after, **args
      end
    end
  end
end
