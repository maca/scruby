module Scruby
  module Ugens
    class In < Ugen
      include MultiOut

      class << self
        # New In with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
        def ar bus, channels = 1
          new :audio, channels, bus
        end
        # New In with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
        def kr bus, channels = 1
          new :control, channels, bus
        end
      end
    end

    class Out < Ugen
      # ar and kr should be use for instantiation
      def initialize *args
        super
        @channels = []
      end

      #:nodoc:
      def output_specs; []; end

      class << self
        # New Out with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
        def ar bus, *inputs
          inputs.peel!
          new :audio, bus, *inputs; 0.0 #Out has no output
        end

        # New Out with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
        def kr bus, *inputs
          inputs.peel!
          new :control, bus, *inputs; 0.0 #Out has no output
        end
      end
    end
  
    class ReplaceOut < Out
    end
  end
end