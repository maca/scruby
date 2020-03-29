require "ruby-osc"
require "concurrent-edge"

module Scruby
  class Server
    class MessageQueue
      include Concurrent
      include OSC

      attr_reader :message_id, :server, :patterns, :thread
      private :message_id, :server, :patterns, :thread

      def initialize(server)
        @server = server
        @message_id = Concurrent::AtomicFixnum.new
        @patterns = Concurrent::Array.new
      end

      def match(cancellation = nil, &block)
        future =
          Promises.resolvable_future.tap { |f| patterns << [ block, f] }

        return future unless cancellation
        Promises.any(future, timeout(cancellation))
      end

      def sync(cancellation = nil)
        id = message_id.increment

        run
        server.send_bundle Message.new("/sync", id)
        match(cancellation) do |msg|
          msg.address == "/synced" && msg.args.first == id
        end
      end

      def run
        return thread if thread&.alive?

        @thread = Thread.new do
          loop do
            dispatch Message.decode(socket.recvfrom(65_535).first)
          end
        end
      end

      def alive?
        thread.alive?
      end
      alias running? alive?

      private

      def dispatch(message)
        patterns.delete_if do |pattern, future|
          future.evaluate_to { message } if pattern === message
        end
      end

      def socket
        server.client.instance_variable_get(:@socket)
      end

      def timeout(cancellation)
        Promises.future(cancellation) do |c|
          loop { c.check!; sleep 0.1 }
        end
      end
    end
  end
end
