module Scruby
  class ServerNode
    module Proxy
      extend Forwardable
      include PrettyInspectable
      include Actions

      def_delegators :node, :name, :id, :params
      attr_reader :server

      def ==(other)
        self.class == other.class && other.id == id
      end

      def group=(group)
        node.parent = group
      end

      def group
        node.parent
      end

      protected

      def node=(node)
        @node = node
      end

      protected

      attr_reader :node
    end
  end
end
