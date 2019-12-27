# frozen_string_literal: true

module Scruby
  module Ugen
    class In < Ugen::Base
      include MultiOut

      class << self
        def ar(bus, channels = 1)
          new :audio, channels, bus
        end

        def kr(bus, channels = 1)
          new :control, channels, bus
        end
      end
    end

    class Out < Ugen::Base
      def initialize(*args)
        super
        @channels = []
      end

      def output_specs; []; end

      class << self
        def ar(bus, *inputs)
          inputs.peel!
          new :audio, bus, *inputs

          0.0 # Out has no output
        end

        def kr(bus, *inputs)
          inputs.peel!
          new :control, bus, *inputs

          0.0 # Out has no output
        end
      end
    end

    class ReplaceOut < Out
    end
  end
end
