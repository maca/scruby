module Scruby
  class Synth
    include Node

    attr_reader :name, :action, :server, :id

    def initialize(name, server)
      @name = name
      super(server)
    end


    private

    attr_reader :target

    def send_new(**args)
      server.send_msg("/s_new", name, id, action_id, target_id, **args)
    end

    class << self
      def after(node, name, **args)
      end

      def before(node, name, **args)
      end

      def head(group, name, **args)
      end

      def after(group, name, **args)
      end
    end
  end
end
