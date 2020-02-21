require "concurrent"
require "singleton"


module Scruby
  class Server
    class Executable
      class Registry
        include Singleton

        def initialize
          at_exit { processes.each(&:kill) }

          Thread.new do
            loop do
              ios, _ = IO.select(processes.map(&:read), nil, nil, 0.5)
              [ *ios ].each(&method(:print_line))
            end
          end
        end

        def register(process)
          processes.push(process)
        end

        def deregister(process)
          processes.delete(process)
        end

        private

        def processes
          @processes ||= Concurrent::Array.new
        end

        def print_line(io)
          line = io.gets
          color = (io.to_i % 6) + 31
          process = processes.find { |p| p.read == io }
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
end
