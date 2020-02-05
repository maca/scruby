require "tty-which"
require "concurrent"
require "forwardable"



module Scruby
  class Server
    class Executable
      extend Forwardable
      include PrettyInspectable

      attr_reader :options, :binary, :pid, :read

      def_delegator :options, :bind_address, :address
      def_delegators :options, :protocol, :port

      def initialize(binary = "scsynth", **options)
        @binary = TTY::Which.which(binary) || binary
        @options = Options.new(options)
      end

      def spawn
        @read, write = IO.pipe
        @pid = Kernel.spawn("#{binary} #{options.flags}",
                            out: write, err: [ :child, :out ])

        write.close

        Process.detach(pid)
        Registry.register(self)
        self
      end

      def alive?
        pid && Process.kill(0, pid) && true
      rescue Errno::ESRCH # No such process
        false
      rescue Errno::EPERM # The process exists
        true
      end

      def kill
        alive? && Process.kill("HUP", pid) && true
      end

      def inspect
        super(binary: binary, port: port)
      end

      def to_s
        "#{binary} port: #{options.port}"
      end

      class << self
        def spawn(binary, **options)
          new(binary, **options).spawn
        end
      end
    end
  end
end
