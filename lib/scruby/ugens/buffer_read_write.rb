module Scruby
  module Ugens
    class PlayBuf < Ugen
      include MultiOut

      class << self
        def kr channels, bufnum = 0, rate = 1.0, trigger = 1.0, start = 0.0, loop = 0.0, doneAction = 0
          new :control, channels, bufnum, rate, trigger, start, loop, doneAction
        end

        def ar channels, bufnum = 0, rate = 1.0, trigger = 1.0, start = 0.0, loop = 0.0, doneAction = 0;
          new :audio, channels, bufnum, rate, trigger, start, loop, doneAction
        end
        named_args_for :kr, :ar
      end
    end

    class TGrains < Ugen
      include MultiOut

      def initialize rate, channels, *inputs
        raise ArgumentError.new("#{ self.class } instance needs at least two channels.") unless channels > 1 
        super
      end

      class << self
        def ar channels, trigger = 0, bufnum = 0, rate = 1, centerPos = 0
          new :audio, channels, trigger, bufnum, rate, centerPos
        end
        named_args_for :ar
      end
    end

    class BufRd < Ugen
      include MultiOut

      class << self
        def kr channels, bufnum = 0, phase = 0.0, loop = 1.0, interpolation = 2
          new :control, channels, bufnum, phase, loop, interpolation
        end

        def ar channels, bufnum = 0, phase = 0.0, loop = 1.0, interpolation = 2
          new :audio, channels, bufnum, phase, loop, interpolation
        end
        named_args_for :kr, :ar
      end
    end

    class BufWr < Ugen
      class << self
        def kr input, bufnum = 0, phase = 0.0, loop = 1.0
          new :control, bufnum, phase, loop, *input.to_array
        end

        def ar input, bufnum = 0, phase = 0.0, loop = 1.0
          new :audio, bufnum, phase, loop, *input.to_array
        end
        named_args_for :kr, :ar
      end
    end

    class RecordBuf < Ugen
      class << self
        def kr input, bufnum = 0, offset = 0.0, rec_level = 1.0, pre_level = 0.0, run = 1.0, loop = 1.0, trigger = 1.0, doneAction=0
          new :control, bufnum, offset, rec_level, pre_level, run, loop, trigger, doneAction, *input.to_array
        end

        def ar input, bufnum = 0, offset = 0.0, rec_level = 1.0, pre_level = 0.0, run = 1.0, loop = 1.0, trigger = 1.0, doneAction=0
          new :audio, bufnum, offset, rec_level, pre_level, run, loop, trigger, doneAction, *input.to_array
        end
        named_args_for :kr, :ar
      end
    end

    class ScopeOut < Ugen
      class << self
        def kr input, bufnum = 0
          new :control, bufnum, *input.to_array
        end

        def ar input, bufnum = 0
          new :audio, bufnum, *input.to_array
        end
        named_args_for :kr, :ar
      end
    end
    
    class Tap < Ugen
      class << self
        def ar bufnum = 0, num_channels = 1, delay_time = 0.2
          PlayBuf.ar num_channels, bufnum, 1, 0, SampleRate.ir.neg * 3, 1
        end
        named_args_for :ar
      end
    end

  end
end
