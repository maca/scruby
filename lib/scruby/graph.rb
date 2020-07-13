module Scruby
  class Graph
    include Enumerable

    attr_reader :nodes, :parent_indices
    private :nodes

    def initialize(nodes)
      @nodes = nodes.map(&method(:node_pair)).to_h
      @parent_indices = nodes.group_by(&:parent)
    end

    def each(&block)
      return enum_for(:each) unless block_given?
      nodes.each(&:last.to_proc >> block)
    end

    def [](idx)
      nodes[idx]
    end

    def children_for(idx)
      parent_indices[idx] || []
    end

    private

    def node_pair(node)
      [ node.id, node.tap { |n| n.graph = self } ]
    end
  end
end
