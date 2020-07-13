module Scruby
  class Server
    class Nodes
      include Enumerable

      attr_reader :semaphore, :graph
      private :semaphore, :graph

      def initialize
        @graph = Graph.new([])
        @semaphore = Mutex.new
      end

      def decode_and_update(msg)
        synchronize  { @graph = Graph::Decoder.decode(msg) }
      end

      def add(node)
        synchronize { graph.add(node) }
      end

      def each(&block)
        synchronize { graph.each(&block) }
      end

      def [](idx)
        synchronize { graph[idx] }
      end

      private

      def synchronize(&block)
        semaphore.synchronize(&block)
      end
    end
  end
end
