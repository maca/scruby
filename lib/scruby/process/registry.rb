require "concurrent"
require "singleton"


module Scruby
  class Process
    class Registry
      include Singleton

      def initialize
        @processes = Concurrent::Array.new

        at_exit { @processes.each(&:kill) }

        Thread.new do
          loop do
            @processes.select!(&:alive?)
            sleep 0.5
          end
        end
      end

      def register(process)
        @processes.push(process)
      end

      def processes
        @processes.dup
      end

      class << self
        def register(process)
          instance.register(process)
        end

        def deregister(process)
          instance.deregister(process)
        end
      end
    end
  end
end
