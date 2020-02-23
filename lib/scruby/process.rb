require "tty-which"
require "forwardable"
require "concurrent-edge"


module Scruby
  class Process
    extend Forwardable
    include PrettyInspectable

    attr_reader :binary, :flags, :pid


    def initialize(binary, flags = "")
      @binary = TTY::Which.which(binary) || binary
      @flags = flags
      @semaphore = Mutex.new
      @reader, @writer = IO.pipe
    end

    def spawn
      return self if alive?

      @stdout, stdoutw = IO.pipe
      stdinr, @stdin = IO.pipe

      @pid = Kernel.spawn("#{binary} #{flags}", in: stdinr,
                          err: [ :child, :out ],
                          out: stdoutw)

      @io_thread = Thread.new { loop &method(:stdout_gets) }

      Registry.register(self)
      ::Process.detach(pid)
      self
    end

    def alive?
      pid && ::Process.kill(0, pid) && true || false
    rescue Errno::ESRCH # No such process
      false
    rescue Errno::EPERM # The process exists
      true
    end

    def kill
      return false unless alive?
      ::Process.kill("HUP", pid)
      io_thread.kill
      true
    end

    def stdin_puts(str)
      stdin.puts(str)
    end

    def read
      ios, _ = IO.select([ reader ], nil, nil, 0.001)
      ios&.first&.gets
    end

    def puts_gets(str)
      semaphore.synchronize {
        true while read
        stdin_puts str
        read
      }
    end

    def inspect
      super(binary: binary)
    end

    private

    attr_reader :semaphore, :stdout, :stdin, :reader, :writer,
                :io_thread

    def stdout_gets
      line = stdout.gets

      writer.puts(line)
      print_line(stdout, line)
    end

    def print_line(io, line)
      color = (io.to_i % 7) + 31
      print "\e[#{color}m[#{binary} #{pid}] #{line}\e[0m\e[1000D"
    end

    class << self
      def spawn(binary, *args)
        new(binary, *args).spawn
      end
    end
  end
end
