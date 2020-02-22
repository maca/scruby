require "tty-which"
require "forwardable"
require "concurrent-edge"


module Scruby
  class Executable
    class Error < StandardError
    end

    extend Forwardable
    include PrettyInspectable

    attr_reader :binary, :flags, :pid


    def initialize(binary, flags = "")
      @binary = TTY::Which.which(binary) || binary
      @flags = flags
    end

    def spawn
      return self if alive?

      @stdout, @stdout_write = IO.pipe
      stdin, @stdin_write = IO.pipe

      @pid = Kernel.spawn("#{binary} #{flags}", in: stdin,
                          err: [ :child, :out ],
                          out: stdout_write)

      start_print_thread

      Registry.register(self)
      Process.detach(pid)
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
      return false unless alive?

      Process.kill("HUP", pid)
      read_thread.kill

      true
    end

    def stdout_puts(str)
      stdout_write.puts(str)
    end

    def stdin_puts(str)
      Concurrent::Promises.future { sync_stdin_puts(str) }
    end

    def inspect
     super(binary: binary)
    end

    private

    def sync_stdin_puts(str)
      read_thread.kill
      raise(Error, "`#{self.inspect}` is dead") unless alive?

      stdin_write.puts(str)
      stdout_gets
    ensure
      start_print_thread
    end

    def start_print_thread
      @read_thread = Thread.new { loop &method(:stdout_print_line) }
    end

    def stdout_gets
      wait_stdout
      stdout.gets.strip
    end

    def stdout_print_line
      wait_stdout
      color = (stdout.to_i % 6) + 31
      print "\e[#{color}m[#{binary} #{pid}] #{stdout.gets}\e[0m\e[1000D"
    end

    def wait_stdout
      IO.select([stdout], nil, nil, 0.5)
    end

    attr_reader :stdout, :stdout_write, :stdin_write, :read_thread

    class << self
      def spawn(binary, *args)
        new(binary, *args).spawn
      end
    end
  end
end
