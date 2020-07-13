module Scruby
  class ServerNode
    module Proxy
      extend Forwardable
      include PrettyInspectable
      include Actions

      def_delegators :node, :name, :server, :group, :id, :params

      def ==(other)
        self.class == other.class && other.id == id
      end

      protected

      def node=(node)
        @node = node
      end

      private

      attr_reader :node
    end
  end
end
