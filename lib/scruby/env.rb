module Scruby
  class Env
    attr_accessor :levels, :times, :curves, :release_node, :array

    SHAPE_NAMES = {
      step: 0,
      lin: 1,
      linear: 1,
      exp: 2,
      exponential: 2,
      sin: 3,
      sine: 3,
      wel: 4,
      welch: 4,
      sqr: 6,
      squared: 6,
      cub: 7,
      cubed: 7
    }.freeze

    def initialize(levels,
                   times,
                   curves: :lin,
                   release_node: nil,
                   loop_node: nil)
      # times should be one less than levels size
      # raise( ArgumentError, 'levels and times must be array')
      @levels = levels
      @times = times
      @curves = curves.to_array
      @release_node = release_node
      @loop_node = loop_node

      unless levels.is_a?(Array) and times.is_a?(Array)
        raise ArgumentError, "levels and times should be array"
      end
    end

    class << self
      def triangle(dur: 1, level: 1)
        dur *= 0.5
        new [ 0, level, 0 ], [ dur, dur ]
      end

      def sine(dur: 1, level: 1)
        dur *= 0.5
        new [ 0, level, 0 ], [ dur, dur ], :sine
      end

      def perc(attackTime: 0.01, releaseTime: 1, level: 1, curve: -4)
        new [ 0, level, 0 ], [ attackTime, releaseTime ], curve
      end

      def linen(attackTime: 0.01, sustainTime: 1, releaseTime: 1,
                level: 1, curve: :lin)

        new [ 0, level, level, 0 ],
            [ attackTime, sustainTime, releaseTime ],
            curve
      end

      def cutoff(releaseTime: 0.1, level: 1, curve: :lin)
        new [ level, 0 ], [ releaseTime ], curve, 0
      end

      def dadsr(delayTime: 0.1, attackTime: 0.01, decayTime: 0.3,
                sustainLevel: 0.5, releaseTime: 1, peakLevel: 1,
                curve: -4, bias: 0)

        new [ 0, 0, peakLevel, peakLevel * sustainLevel, 0 ]
          .map{ |e| e + bias },
            [ delayTime, attackTime, decayTime, releaseTime ],
            curve,
            3
      end

      def adsr(attackTime: 0.01, decayTime: 0.3, sustainLevel: 0.5,
               releaseTime: 1, peakLevel: 1, curve: -4, bias: 0)

        new [ 0, peakLevel, peakLevel * sustainLevel, 0 ]
          .map{ |e| e + bias },
            [ attackTime, decayTime, releaseTime ], curve, 2
      end

      def asr(attackTime: 0.01, sustainLevel: 1, releaseTime: 1,
              curve: -4)

        new [ 0, sustainLevel, 0 ], [ attackTime, releaseTime ], curve, 1
      end
    end

    def to_array
      contents = levels[0], times.size, release_node, loop_node
      contents + levels[1..-1]
                 .wrap_and_zip(times, shape_numbers, curve_values)
                 .flatten
    end

    def shape_numbers
      curves.map do |curve|
        Ugens::Ugen.valid_input?(curve) ? 5 : SHAPE_NAMES[curve]
      end
    end

    def curve_values
      curves.map do |curve|
        Ugens::Ugen.valid_input?(curve) ? curve : 0
      end
    end

    def release_node
      @release_node ||= -99
    end

    def loop_node
      @loop_node ||= -99
    end

    def constants; end
  end
end
