module Scruby
  class Synth < Node
    attr_reader :name
    
    def initialize name, servers
      super servers
      @name = name.to_s
    end
    
    protected


    class << self
      def new name, args = {}, target = nil, action = :head
        servers, target_id = params_from_target target
        synth = instantiate name, servers
        synth.send '/s_new', synth.name, synth.id, Node::ACTIONS.index(action), target_id, *args.to_a.flatten
        synth
      end
      
      def paused
      end
      
      def after
      end
      
      # before
      # head
      # tail
      # replace
      
      # def as_target obj
      #         case obj
      #         when Server then Group.new obj, 1
      #         when Node then obj
      #         when nil then Group.new 
      #         end
      #       end
      
      
      private
      def params_from_target target
        servers     = target.servers if target.respond_to? :servers
        target_id   = target if target.is_a? Integer
        target_id ||= target.respond_to?(:node_id) ? target.node_id : 1
        [servers, target_id]
      end
      
      def instantiate *args 
        obj = allocate
        obj.__send__ :initialize, *args
        obj
      end
    end

  end
end