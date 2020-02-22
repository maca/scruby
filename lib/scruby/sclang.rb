module Scruby
  class Sclang
    def initialize
      @executable = Executable.new("sclang", "-i scruby")
    end

    def spawn
      executable.spawn && self
    end

    def execute(code)
      [ "(", *code.split("\n"), ").postcs" ].each do |line|
        write escape(line)
      end

      write("\e")
    end

    private

    def write(str)
      executable.write_stdin(str)
    end

    def escape(str)
      str.dump[1..-2].gsub("\\\\", "\\")
    end

    attr_reader :executable

    class << self
      def spawn
        new.spawn
      end
    end
  end
end
