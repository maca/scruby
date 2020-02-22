module Scruby
  class Sclang
    def initialize
      @executable = Executable.new("sclang", "-i scruby")
    end

    def spawn
      executable.spawn && self
    end

    def kill
      executable.kill
    end

    def execute(code)
      async_execute(code).value!
    end

    def async_execute(code)
      executable.stdin_puts "(#{code}).postcs \e"
    end

    private

    attr_reader :executable

    class << self
      def spawn
        new.spawn
      end
    end
  end
end
