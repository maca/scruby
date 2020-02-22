module Scruby
  class Sclang
    def initialize
      @process = Process.new("sclang", "-i scruby")
    end

    def spawn
      process.spawn && self
    end

    def kill
      process.kill
    end

    def eval(code)
      async_eval(code).value!
    end

    def async_eval(code)
      process.stdin_puts "(#{code}).postcs \e"
    end

    private

    attr_reader :process

    class << self
      def spawn
        new.spawn
      end
    end
  end
end
