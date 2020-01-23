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
        id = message_id.increment

        Promises.future(Cancellation.timeout(timeout)) do |cancelation|
          loop do
            cancelation.check!

            reply = send_sync(id)
            break reply if reply
          end
        end
      end

      private

      def send_sync(id)
        server.send_bundle(nil, Message.new("/sync", id))
        msg = Message.decode socket.recvfrom(65_535).first

        return unless msg.address == "/synced" && msg.args.first == id
        msg
      rescue Errno::ECONNREFUSED
      end
    end
  end
end
