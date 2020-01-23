require "concurrent"


module Scruby
  class Server
    class Executable
      class Registry
        include Singleton

        def initialize
          at_exit { processes.each(&:kill) }

          Thread.new do
            loop do
              processes.select!(&:alive?)
              ios, _ = IO.select(processes.map(&:read), nil, nil, 1)

              [ *ios ].each do |io|
                io.each { |line| print_line(io, line) }
              end
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

        def print_line(io, line)
          color = (io.to_i % 6) + 31
          process = processes.find { |p| p.read == io }
          print "\e[#{color}m[#{process}] #{line}\e[0m"
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
