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

      def receive(address = nil, timeout: nil, &pred)
        run

        future = Promises.resolvable_future.tap do |f|
          patterns << [ address || pred, f ]
        end

        return future unless timeout
        Promises.any(future, cancellation_future(timeout))
      end

      def sync
        id = message_id.increment

        server.send_bundle Message.new("/sync", id)
        receive(timeout: 0.2) do |msg|
          msg.address == "/synced" && msg.args.first == id
        end
      end

      def status
        keys = %i(ugens synths groups synth_defs avg_cpu peak_cpu
          sample_rate actual_sample_rate)

        server.send_msg Message.new("/status")
        receive("/status.reply", timeout: 0.2)
          .then { |msg| keys.zip(msg.args[1..-1]).to_h }
      end

      def run
        return thread if alive?

        @thread = Thread.new do
          loop { dispatch socket.recvfrom(65_535).first }
        end
      end

      def alive?
        thread&.alive? || false
      end
      alias running? alive?

      def stop
        return self unless alive?

        thread.kill

        patterns.delete_if do |_, future|
          future.reject CancelledOperationError.new("server quitted")
        end

        self
      end

      private

      def dispatch(raw)
        message = OSC.decode(raw)

        patterns.delete_if do |pattern, future|
          if  pattern === message || pattern === message.address
            future.evaluate_to { message }
          end
          rescue
        end
      end

      def socket
        server.client.instance_variable_get(:@socket)
      end

      def cancellation_future(timeout)
        cancellation = Cancellation.timeout(timeout)

        Promises.future(cancellation) do |c|
          loop { c.check!; sleep 0.1 }
        end
      end
    end
  end
end
