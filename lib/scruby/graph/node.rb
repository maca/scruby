module Scruby
  class Graph
    class Node
      attr_reader :name, :params
      attr_accessor :id, :parent, :graph

      def initialize(name = nil, **params)
        @name = name
        @params = params
      end

      def children
        graph.children_for(self)
      end
    end
  end
end
