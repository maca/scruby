require "concurrent"
require "singleton"


module Scruby
  class Executable
    class Registry
      include Singleton

      def initialize
        @processes = Concurrent::Array.new

        at_exit { @processes.each(&:kill) }

        Thread.new do
          loop do
            @processes.select!(&:alive?)

            ios, _ = IO.select(@processes.map(&:stdout), nil, nil, 0.5)
            [ *ios ].each(&method(:print_line))
          end
        end
      end

      def register(process)
        @processes.push(process)
      end

      def deregister(process)
        @processes.delete(process)
      end

      def processes
        @processes.dup
      end

      private

      def print_line(io)
        line = io.gets
        process = @processes.find { |p| p.stdout == io }
        color = (io.to_i % 6) + 31
        print "\e[#{color}m[#{process}] #{line}\e[0m\e[1000D"
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
