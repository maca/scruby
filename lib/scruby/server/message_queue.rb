require "ruby-osc"
require "concurrent-edge"

module Scruby
  class Server
    class MessageQueue
      include Concurrent
      include OSC

      attr_reader :message_id, :server
      private :message_id, :server

      def initialize(server)
        @server = server
        @message_id = Concurrent::AtomicFixnum.new
      end

      def socket
        server.client.instance_variable_get(:@socket)
      end

      def sync(timeout = 5)
        Promises.future Cancellation.timeout(timeout), &method(:do_sync)
      end

      private

      def do_sync(cancelation)
        id = message_id.increment

        loop do
          cancelation.check!
          return server if send_sync(id)
        end
      end

      def send_sync(id)
        server.send_bundle Message.new("/sync", id)
        msg = Message.decode socket.recvfrom(65_535).first

        msg.address == "/synced" && msg.args.first == id
      rescue Errno::ECONNREFUSED
      end
    end
  end
end
