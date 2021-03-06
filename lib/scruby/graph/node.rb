module Scruby
  class Graph
    class Node
      attr_accessor :obj, :id, :parent, :graph

      def initialize(obj = nil, id = nil, parent = nil)
        @obj, @id, @parent = obj, id, parent
      end

      def children
        graph.children_for(self)
      end

      def ==(other)
        self.class == other.class &&
          self.id == other.id &&
          self.graph == other.graph
      end
    end
  end
end
