require "tty-which"
require "concurrent"
require "forwardable"


module Scruby
  class Executable
    extend Forwardable
    include PrettyInspectable

    attr_reader :binary, :flags, :pid, :stdout, :stdin


    def initialize(binary, flags = "")
      @binary = TTY::Which.which(binary) || binary
      @flags = flags
    end

    def spawn
      return self if alive?

      @stdout, @stdout_write = IO.pipe
      stdin_read, @stdin = IO.pipe

      @pid = Kernel.spawn("#{binary} #{flags}", in: stdin_read,
                          out: stdout_write)

      Process.detach(pid)
      Registry.register(self)
      self
    end

    def alive?
      pid && Process.kill(0, pid) && true || false
    rescue Errno::ESRCH # No such process
      false
    rescue Errno::EPERM # The process exists
      true
    end

    def kill
      alive? && Process.kill("HUP", pid) && true
    end

    def puts(str)
      stdout_write.puts(s tr)
    end

    def write_stdin(str)
      stdin.puts(str)
    end

    def inspect
     super(binary: binary)
    end

    def to_s
      "#{binary} #{pid}"
    end

    private

    attr_reader :stdout_write

    class << self
      def spawn(binary, *args)
        new(binary, *args).spawn
      end
    end
  end
end
