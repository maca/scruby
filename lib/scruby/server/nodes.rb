module Scruby
  class Server
    class Nodes
      include Enumerable

      attr_reader :server, :semaphore, :graph
      private :server, :semaphore

      def initialize(server)
        @graph = Graph.new([])
        @server = server
        @semaphore = Mutex.new
      end

      def decode_and_update(msg)
        graph = Graph::Decoder.decode(msg)
        synchronize { @graph = graph }
        self
      end

      def clear
        synchronize { @graph = Graph.new([]) }
      end

      def add(node)
        synchronize { graph.add(node) }
      end

      def each(&block)
        graph.to_a.each(&method(:wrap) >> block)
      end

      def children_for(node)
        graph.children_for(node).map(&method(:wrap))
      end

      def [](idx)
        wrap node(idx)
      end

      def node(idx)
        synchronize { graph[idx] }
      end

      def print
        first.print
      end

      def inspect
        print
      end

      private

      def synchronize(&block)
        semaphore.synchronize(&block)
      end

      def wrap(node)
        return Group.new(server, node.id) if node.obj&.name.nil?
        Synth.new(server, node.id)
      end
    end
  end
end
