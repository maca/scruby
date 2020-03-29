require "ruby-osc"
require "concurrent-edge"

module Scruby
  class Server
    class MessageQueue
      include Concurrent
      include OSC

      attr_reader :message_id, :server, :patterns
      private :message_id, :server, :patterns

      def initialize(server)
        @server = server
        @message_id = Concurrent::AtomicFixnum.new
        @patterns = Concurrent::Array.new

        Thread.new do
          loop do
            dispatch Message.decode(socket.recvfrom(65_535).first)
          rescue Errno::ECONNREFUSED
          end
        end
      end

      def match(&block)
        Promises.resolvable_future.tap { |f| patterns << [ block, f ] }
      end

      def sync(timeout = 5)
        id = message_id.increment

        server.send_bundle Message.new("/sync", id)
        match { |msg| msg.address == "/synced" && msg.args.first == id }
      end

      private

      def dispatch(message)
        patterns.delete_if do |pattern, future|
          future.evaluate_to { message } if pattern === message
        end
      end

      def socket
        server.client.instance_variable_get(:@socket)
      end
    end
  end
end
