require "concurrent-edge"


module Scruby
  class SclangError < StandardError; end

  class Sclang
    include Concurrent

    def initialize
      @process = Process.new("sclang", "-i scruby")
    end

    def spawn
      spawn_async.value!
    end

    def spawn_async
      return Promises.fulfilled_future(self) if process.alive?

      process.spawn

      Promises.future(Cancellation.timeout(3)) do |cancelation|
        loop {
          case process.read
          when /Welcome/ then break
          when /Error/ then raise(SclangError, "failed to spawn sclang")
          else
            cancelation.check!
          end
        }

        self
      end
    end

    def kill
      process.kill
    end

    def eval(code)
      unless process.alive?
        raise SclangError, "sclang process not running, try `sclang.spawn`"
      end

      eval_async(code).value!
    end

    def eval_async(code)
      Promises.future do
        process.puts_gets("(#{code}).postcs \e")&.strip
      end
    end

    private

    attr_reader :process

    class << self
      def spawn
        new.spawn
      end

      def main
        @main ||= new
      end
    end
  end
end
