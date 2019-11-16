module Scruby
  module Ugens
    class Pan2 < Ugen
      include MultiOut

      class << self
        def ar(input, pos: 0.0, level: 1.0)
          new :audio, 2, input, pos, level
        end

        def kr(input, pos: 0.0, level: 1.0)
          new :control, 2, input, pos, level
        end
      end
    end

    class LinPan2 < Pan2; end

    class Pan4 < Ugen
      include MultiOut

      class << self
        def ar(input, xpos: 0.0, ypos: 0.0, level: 1.0)
          new :audio, 4, input, xpos, ypos, level
        end

        def kr(input, xpos: 0.0, ypos: 0.0, level: 1.0)
          new :control, 4, input, xpos, ypos, level
        end
      end
    end

    class Balance2 < Ugen
      include MultiOut

      class << self
        def ar(left, right, pos: 0.0, level: 1.0)
          new :audio, 2, left, right, pos, level
        end

        def kr(left, right, pos: 0.0, level: 1.0)
          new :control, 2, left, right, pos, level
        end
      end
    end

    class Rotate2 < Ugen
      include MultiOut

      class << self
        def ar(x, y, pos: 0.0)
          new :audio, 2, x, y, pos
        end

        def kr(x, y, pos: 0.0)
          new :control, 2, x, y, pos
        end
      end
    end

    class PanB < Ugen
      include MultiOut

      class << self
        def ar(input, azimuth: 0, elevation: 0, gain: 1)
          new :audio, 4, input, azimuth, elevation, gain
        end

        def kr(input, azimuth: 0, elevation: 0, gain: 1)
          new :control, 4, input, azimuth, elevation, gain
        end
      end
    end

    class PanB2 < Ugen
      include MultiOut

      class << self
        def ar(input, azimuth: 0, gain: 1)
          new :audio, 3, input, azimuth, gain
        end

        def kr(input, azimuth: 0, gain: 1)
          new :control, 3, input, azimuth, gain
        end
      end
    end

    class BiPanB2 < Ugen
      include MultiOut

      class << self
        def ar(a, b, azimuth, gain: 1)
          new :audio, 3, a, b, azimuth, gain
        end

        def kr(a, b, azimuth, gain: 1)
          new :control, 3, a, b, azimuth, gain
        end
      end
    end

    class DecodeB2 < Ugen
      include MultiOut

      class << self
        def ar(num_channels, w, x, y, orientation: 0.5)
          new :audio, num_channels, w, x, y, orientation
        end

        def kr(num_channels, w, x, y, orientation: 0.5)
          new :control, num_channels, w, x, y, orientation
        end
      end
    end

    class PanAz < Ugen
      include MultiOut

      class << self
        def ar(num_channels, input, pos: 0.0, level: 1.0, width: 2.0,
               orientation: 0.5)

          new :audio, num_channels, input, pos, level, width,
              orientation
        end

        def kr(num_channels, input, pos: 0.0, level: 1.0, width: 2.0,
               orientation: 0.5)

          new :control, num_channels, input, pos, level, width,
              orientation
        end
      end
    end
  end
end
