module Scruby
  class Sclang
    def initialize
      @executable = Executable.new("sclang", "-i scruby")
    end

    def spawn
      executable.spawn && self
    end

    def execute(code)
      executable.write_stdin "(#{code}).postcs \e"
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
