module Scruby
  class Synth < Node
    attr_reader :name

    def initialize(name, servers)
      super servers
      @name = name.to_s
    end

    class << self
      def new(name, args = {}, target = nil, action = :head)
        case target
        when nil
          target_id, servers = 1, nil
        when Group
          target_id, servers = group.id, target.servers
        when Node
          target_id, servers = 1, target.servers
        else
          raise TypeError, "expected #{ target } to kind of Node or nil"
        end

        synth = super name, servers
        synth.send "/s_new", synth.name, synth.id, Node::ACTIONS.index(action), target_id, args
        synth
      end

      def after(target, name, args = {})
        new name, args, target, :after
      end

      def before(target, name, args = {})
        new name, args, target, :before
      end

      def head(target, name, args = {})
        new name, args, target, :head
      end

      def tail(target, name, args = {})
        new name, args, target, :tail
      end

      def replace(target, name, args = {})
        new name, args, target, :replace
      end
    end
  end
end
