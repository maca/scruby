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

        Promises.future(Cancellation.timeout(timeout)) do |cancel|
          loop do
            begin
              cancel.check!
              server.send_bundle Message.new("/sync", id)

              match = message_matching do |msg|
                msg.address == "/synced" && msg.args.first == id
              end

              break server if match
            rescue Errno::ECONNREFUSED
              retry
            end
          end
        end
      end

      def message_matching
        msg = Message.decode socket.recvfrom(65_535).first
        msg if yield(msg)
      end
    end
  end
end
