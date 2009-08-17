module Scruby
  module Ugens
    
    class Panner < MultiOutUgen
      def initialize rate, inputs, channels
        super rate, *(0...channels).map{ |i| OutputProxy.new(rate, self, i) }
        @inputs = inputs
        inputs.each do |i|
          raise ArgumentError.new("input #{ i } has not audio rate.") unless i.rate == :audio if Ugen === i 
        end if rate == :audio
      end
    end
    
    class Pan2 < Panner
      def initialize rate, *inputs
        super rate, inputs, 2
      end
      
      class << self
        def ar input, pos = 0.0, level = 1.0
          new :audio, input, pos, level
        end
      
        def kr input, pos = 0.0, level = 1.0
          new :control, input, pos, level
        end
        named_args_for :ar, :kr
      end
    end
    
    class LinPan2 < Pan2; end
    
    class Pan4 < Panner
      def initialize rate, *inputs
        super rate, inputs, 4
      end
      
      class << self
        def ar input, xpos = 0.0, ypos = 0.0, level = 1.0
          new :audio, input, xpos, ypos, level
        end
      
        def kr input, xpos = 0.0, ypos = 0.0, level = 1.0
          new :control, input, xpos, ypos, level
        end
        
        named_args_for :ar, :kr
      end
    end
  
    class Balance2 < Panner
      def initialize rate, *inputs
        super rate, inputs, 2
      end
      
      class << self
        def ar left, right, pos = 0.0, level = 1.0
          new :audio, left, right, pos, level
        end
      
        def kr left, right, pos = 0.0, level = 1.0
          new :control, left, right, pos, level
        end
        named_args_for :ar, :kr
      end
    end
  
    class Rotate2 < Panner
      def initialize rate, *inputs
        super rate, inputs, 2
      end
      
      class << self
        def ar x, y, pos = 0.0
          new :audio, x, y, pos
        end
      
        def kr x, y, pos = 0.0
          new :control, x, y, pos
        end
      end
    end
 
    class PanB < Panner
      def initialize rate, *inputs
        super rate, inputs, 4
      end

      class << self
        def ar input, azimuth = 0, elevation = 0, gain = 1
          new :audio, input, azimuth, elevation, gain
        end

        def kr input, azimuth = 0, elevation = 0, gain = 1
          new :control, input, azimuth, elevation, gain
        end
        named_args_for :ar, :kr
      end
    end
    
    class PanB2 < Panner
      def initialize rate, *inputs
        super rate, inputs, 3
      end

      class << self
        def ar input, azimuth = 0, gain = 1
          new :audio, input, azimuth, gain
        end

        def kr input, azimuth = 0, gain = 1
          new :control, input, azimuth, gain
        end
        named_args_for :ar, :kr
      end
    end
    
    class BiPanB2 < Panner
      def initialize rate, *inputs
        super rate, inputs, 3
      end

      class << self
        def ar a, b, azimuth, gain = 1
          new :audio, a, b, azimuth, gain
        end

        def kr a, b, azimuth, gain = 1
          new :control, a, b, azimuth, gain
        end
      end
    end
    
    class DecodeB2 < Panner
      def initialize rate, num_channels, *inputs
        super rate, inputs, num_channels
      end

      class << self
        def ar num_channels, w, x, y, orientation = 0.5
          new :audio, num_channels, w, x, y, orientation
        end

        def kr num_channels, w, x, y, orientation = 0.5
          new :control, num_channels, w, x, y, orientation
        end
      end
    end
  
    class PanAz < Panner
      def initialize rate, num_channels, *inputs
        super rate, inputs, num_channels
      end

      class << self
        def ar num_channels, input, pos = 0.0, level = 1.0, width = 2.0, orientation = 0.5
          new :audio, num_channels, input, pos, level, width, orientation
        end

        def kr num_channels, input, pos = 0.0, level = 1.0, width = 2.0, orientation = 0.5
          new :control, num_channels, input, pos, level, width, orientation
        end
      end
    end

  end
end