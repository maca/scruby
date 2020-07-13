module Scruby
  class Server
    class Nodes
      include Enumerable

      attr_reader :semaphore, :graph
      private :semaphore

      def initialize
        @graph = Graph.new([])
        @semaphore = Mutex.new
      end

      def decode_and_update(msg)
        graph = Graph::Decoder.decode(msg)
        synchronize  { @graph = graph }
      end

      def add(node)
        synchronize { graph.add(node) }
      end

      def each(&block)
        graph.to_a.each(&block)
      end

      def [](idx)
        synchronize { graph[idx] }
      end

      def print
        first.print
      end

      private

      def synchronize(&block)
        semaphore.synchronize(&block)
      end
    end
  end
end
