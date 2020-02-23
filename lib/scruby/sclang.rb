require "concurrent-edge"


module Scruby
  class SclangError < StandardError; end

  class Sclang
    include Concurrent

    def initialize
      @process = Process.new("sclang", "-i scruby")
    end

    def spawn
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
      async_eval(code).value!
    end

    def async_eval(code)
      true while process.read

      Promises.future do
        process.stdin_puts "(#{code}).postcs \e"
        process.read.to_s.strip
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
