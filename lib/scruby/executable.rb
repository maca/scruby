require "tty-which"
require "concurrent"
require "forwardable"


module Scruby
  class Executable
    extend Forwardable
    include PrettyInspectable

    attr_reader :binary, :flags, :pid, :std_out


    def initialize(binary, flags = "")
      @binary = TTY::Which.which(binary) || binary
      @flags = flags
    end

    def spawn
      @std_out, @std_out_write = IO.pipe
      @pid = Kernel.spawn("#{binary} #{flags}",
                          out: std_out_write, err: [ :child, :out ])

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
      super(binary: binary)
    end

    def puts(str)
      std_out_write.puts str
    end

    def to_s
      "#{binary} #{pid}"
    end

    private

    attr_reader :std_out_write

    class << self
      def spawn(binary, *args)
        new(binary, *args).spawn
      end
    end
  end
end
