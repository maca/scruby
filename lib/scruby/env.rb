module Scruby
  class Env
    include Equatable

    attr_reader :levels, :times, :curves, :release_node, :loop_node

    SHAPES = {
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
      cubed: 7,
      hold: 8
    }.freeze


    def initialize(levels = [0, 1, 0], times = [1, 1],
                   curves: :lin, release_node: nil, loop_node: nil)

      @levels = levels.to_a
      @times = times.cycle.take(levels.size - 1)
      @curves = [*curves]
      @release_node = release_node
      @loop_node = loop_node
    end

    def duration
      times.sum
    end

    def range
    end

    def exp_range
    end

    def curve_range
    end

    def release_range
    end

    def sustained?
      !release_node.nil?
    end

    def release_time
      return 0 if release_node.nil?
      times[release_node..-1].sum
    end

    def to_a
      # contents = levels[0], times.size, release_node, loop_node
      # contents + levels[1..-1]
      #            .wrap_and_zip(times, shape_numbers, curve_values)
      #            .flatten
    end

    def to_signal
    end

    def to_multichannel_signal
    end

    def discretize
    end

    def kr(*args, **opts)
      EnvGen.kr(self, *args, **opts)
    end

    def ar(*args, **opts)
      EnvGen.ar(self, *args, **opts)
    end

    def state
      [ levels, times, curves_numbers, loop_node, release_node ]
    end

    private

    def curves_numbers
      curves.map { |curve| SHAPES.fetch(curve, 5) }
    end

    def curve_values
      curves.map do |curve|
        Ugens::Ugen.valid_input?(curve) ? curve : 0
      end
    end

    class << self
      def triangle(dur: 1, level: 1)
        new([ 0, level, 0 ], [ dur * 0.5, dur * 0.5 ])
      end

      def sine(dur: 1, level: 1)
        new([ 0, level, 0 ], [ dur * 0.5, dur * 0.5 ], curves: :sine)
      end

      def perc(attack: 0.01, release: 1, level: 1, curves: -4)
        new([ 0, level, 0 ], [ attack, release ], curve)
      end

      def linen(attack: 0.01, sustain: 1, release: 1, level: 1,
                curves: :lin)

        levels = [ 0, level, level, 0 ]
        times = [ attack, sustain, release ]

        new(levels, times, curves: curves)
      end

      def step
      end

      def cutoff(release: 0.1, level: 1, curves: :lin)
        # var releaseLevel = if(curveNo == 2) { -100.dbamp } { 0 };
        new([ level, 0 ], [ release ], curves: curves, release_node: 0)
      end

      def dadsr(delay: 0.1, attack: 0.01, decay: 0.3,
                sustain_level: 0.5, release: 1, peak_level: 1,
                curves: -4, bias: 0)

        levels = [ 0, 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }
        times = [ delay, attack, decay, release ]

        new(levels, times, curves: curves, release_node: 3)
      end

      def adsr(attack: 0.01, decay: 0.3, sustain_level: 0.5,
               release: 1, peak_level: 1, curves: -4, bias: 0)

        levels = [ 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }
        times = [ attack, decay, release ]

        new(levels, times, curves: curves, release_node: 2)
      end

      def asr(attack: 0.01, sustain_level: 1, release: 1, curves: -4)
        levels = [ 0, sustain_level, 0 ]
        times = [ attack, release ]

        new(levels, times, curves: curves, release_node: 1)
      end

      # def circle(levels: nil, times: nil, curves: :lin)
      #   times = [*times].cycle.take(levels.size)
      #   curves = [*curve].cycle.take(levels.size)

      #   new(levels, times[0..-1], curve[0..-1])
      #     .circle(times.last, curves.last)
      # end
    end
  end
end
