require "ruby-osc"
require "concurrent-edge"

module Scruby
  class Server
    class MessageQueue
      include Concurrent
      include OSC

      attr_reader :message_id, :server, :patterns, :thread
      attr_accessor :debug

      private :message_id, :server, :patterns, :thread

      def initialize(server)
        @server = server
        @message_id = Concurrent::AtomicFixnum.new
        @patterns = Concurrent::Array.new
      end

      def receive(address = nil, timeout: nil, &pred)
        run

        future = Promises.resolvable_future
        patterns << [ address, pred, future ]

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
        msg = OSC.decode(raw)
        puts "[#{server}] sent: #{msg.inspect}" if debug
        dispatch_msg msg
      end

      def dispatch_msg(message)
        patterns.delete_if do |pattern, pred, future|
          match =
            (pattern || pred) &&
            (pattern.nil? || pattern === message.address) &&
            (pred.nil? || pred.call(message, future))

          next unless match

          future.evaluate_to { message } if future.pending?
          true
        rescue StandardError => e
          puts e
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
