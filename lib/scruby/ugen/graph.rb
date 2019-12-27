module Scruby
  module Ugen
    class Graph
      include Scruby::Encode

      # def initialize(root)
      #   @root = Node.new(root, self)
      # end

      def add(proxy)
        nodes.push(proxy)
      end

      def encode
      end

      private

      def nodes
        @nodes ||= Concurrent::Array.new
      end
    end
  end
end
