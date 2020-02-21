require "tty-which"
require "concurrent"
require "forwardable"


module Scruby
  class Executable
    extend Forwardable
    include PrettyInspectable

    attr_reader :binary, :flags, :label, :pid, :read


    def initialize(binary, flags = "", label = nil)
      @binary = TTY::Which.which(binary) || binary
      @flags = flags
      @label = label || binary
    end

    def spawn
      @read, @write = IO.pipe
      @pid = Kernel.spawn("#{binary} #{flags}",
                          out: write, err: [ :child, :out ])

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

    def puts(str)
      write.puts str
    end

    private

    attr_reader :write

    class << self
      def spawn(binary, *args)
        new(binary, *args).spawn
      end
    end
  end
end
