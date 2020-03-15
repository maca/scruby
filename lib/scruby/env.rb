module Scruby
  class Env
    include Equatable

    attr_reader :levels, :curves, :release_at, :loop_at, :offset

    SHAPES = {
      step: 0,
      linear: 1,
      exponential: 2,
      sine: 3,
      welch: 4,
      squared: 6,
      cubed: 7,
      hold: 8
    }.freeze

    SHAPES_ALIAS = {
      lin: :linear,
      exp: :exponential,
      sin: :sine,
      wel: :welch,
      sqr: :squared,
      cub: :cubed
    }.freeze


    def initialize(levels: [0, 1, 0], times: [1, 1], curves: :lin,
                   release_at: nil, loop_at: nil, offset: 0)

      @levels = levels
      @times = times
      @curves = [*curves].map { |c| SHAPES_ALIAS.fetch(c, c) }
      @release_at = release_at
      @loop_at = loop_at
      @offset = offset
    end

    def times
      @times.cycle.take(levels.size - 1)
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
      !release_at.nil?
    end

    def release_time
      return 0 if release_at.nil?
      times[release_at..-1].sum
    end

    def to_a
      contents = [ levels.first, times.size,
                   release_at || -99,
                   loop_at || -99 ]

      contents + levels[1..-1].zip(
        times, shape_numbers.cycle.take(levels.size - 1),
        shape_values.cycle.take(levels.size - 1)
      ).flatten
    end


    def at_time(time)
      curves = self.curves.cycle.take(times.size)
      initial = [0, levels.first]

      return levels.last if time > duration

      times.zip(levels[1..-1], curves)
        .inject(initial) do |acc, (duration, end_level, curve)|

        start_time, start_level = acc
        end_time = start_time + duration

        next [ end_time, end_level ] if time > end_time

        pos = (time.to_f - start_time) / duration

        level =
          case curve
          when :linear
            pos * (end_level - start_level) + start_level
          end

        return level

      end
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
      [ levels, times, shape_numbers, loop_at, release_at ]
    end

    private

    def shape_numbers
      curves.map { |curve| SHAPES.fetch(curve, 5) }
    end

    def shape_values
      curves.map do
        0
        # Ugens::Ugen.valid_input?(curve) ? curve : 0
      end
    end

    class << self
      def triangle(dur: 1, level: 1)
        new(levels: [ 0, level, 0 ], times: [ dur * 0.5, dur * 0.5 ])
      end

      def sine(dur: 1, level: 1)
        levels = [ 0, level, 0 ]
        times = [ dur * 0.5, dur * 0.5 ]

        new(levels: levels, times: times, curves: :sine)
      end

      def perc(attack: 0.01, release: 1, level: 1, curves: -4)
        levels = [ 0, level, 0 ]
        times = [ attack, release ]

        new(levels: levels, times: times, curves: curves)
      end

      def linen(attack: 0.01, sustain: 1, release: 1, level: 1,
                curves: :lin)

        levels = [ 0, level, level, 0 ]
        times = [ attack, sustain, release ]

        new(levels: levels, times: times, curves: curves)
      end

      def step
      end

      def cutoff(release: 0.1, level: 1, curves: :lin)
        # var releaseLevel = if(curveNo == 2) { -100.dbamp } { 0 };
        levels = [ level, 0 ]
        times = [ release ]

        new(levels: levels, times: times, curves: curves, release_at: 0)
      end

      def dadsr(delay: 0.1, attack: 0.01, decay: 0.3,
                sustain_level: 0.5, release: 1, peak_level: 1,
                curves: -4, bias: 0)

        levels = [ 0, 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }
        times = [ delay, attack, decay, release ]

        new(levels: levels, times: times, curves: curves, release_at: 3)
      end

      def adsr(attack: 0.01, decay: 0.3, sustain_level: 0.5,
               release: 1, peak_level: 1, curves: -4, bias: 0)

        levels = [ 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }
        times = [ attack, decay, release ]

        new(levels: levels, times: times, curves: curves, release_at: 2)
      end

      def asr(attack: 0.01, sustain_level: 1, release: 1, curves: -4)
        levels = [ 0, sustain_level, 0 ]
        times = [ attack, release ]

        new(levels: levels, times: times, curves: curves, release_at: 1)
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
