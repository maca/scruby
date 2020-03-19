module Scruby
  class Env
    include Equatable
    include Utils::PositionalKeywordArgs
    extend Utils::PositionalKeywordArgs

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


    SHAPE_ALIASES = {
      lin: :linear,
      exp: :exponential,
      sin: :sine,
      wel: :welch,
      sqr: :squared,
      cub: :cubed
    }.freeze


    DEFAULTS = {
      levels: [ 0, 1, 0 ],
      times: [ 1, 1 ],
      curves: :lin,
      release_at: nil,
      loop_at: nil,
      offset: 0,
    }.freeze


    TRIANGLE_DEFAULTS = { dur: 1, level: 1 }.freeze

    SINE_DEFAULTS = { dur: 1, level: 1 }.freeze

    PERC_DEFAULTS = {
      attack: 0.01,
      release: 1,
      level: 1,
      curves: -4
    }.freeze

    LINEN_DEFAULTS = {
      attack: 0.01,
      sustain: 1,
      release: 1,
      level: 1,
      curves: :lin
    }.freeze

    CUTOFF_DEFAULTS = { release: 0.1, level: 1, curves: :lin }.freeze

    DADSR_DEFAULTS = {
      delay: 0.1,
      attack: 0.01,
      decay: 0.3,
      sustain_level: 0.5,
      release: 1,
      peak_level: 1,
      curves: -4,
      bias: 0
    }.freeze

    ADSR_DEFAULTS = {
      attack: 0.01,
      decay: 0.3,
      sustain_level: 0.5,
      release: 1,
      peak_level: 1,
      curves: -4,
      bias: 0
    }.freeze

    ASR_DEFAULTS = {
      attack: 0.01,
      sustain_level: 1,
      release: 1,
      curves: -4
    }.freeze


    def initialize(*args, **kwargs)
      params = positional_keyword_args(DEFAULTS, *args, **kwargs)

      @levels = params[:levels]
      @times = params[:times]
      @curves = [ *params[:curves] ].map { |c| SHAPE_ALIASES[c] || c }
      @release_at = params[:release_at]
      @loop_at = params[:loop_at]
      @offset = params[:offset]
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

    def encode
      numbers, values = [ shape_numbers, shape_values ].map do |ary|
        ary.cycle.take(levels.size - 1)
      end

      [ levels.first, times.size,
        release_at || -99, loop_at || -99,
        *levels[1..-1].zip(times, numbers, values).flatten
      ]
    end

    def interpolate(step = 1)
      if block_given?
        (0..duration).step(step).each { |time| yield at_time(time) }
        return self
      end

      size = duration.fdiv(step).ceil + 1
      Enumerator.new(size) { |y| interpolate(step, &y.method(:yield)) }
    end

    def at_time(time)
      curves = self.curves.cycle.take(times.size)
      initial = [ 0, levels.first ]

      return levels.last.to_f if time >= duration

      times.zip(levels[1..-1], curves)
        .reduce(initial) do |acc, (duration, end_level, curve)|

        start_time, start_level = acc
        end_time = start_time + duration

        next [ end_time, end_level ] if time >= end_time

        pos = (time.to_f - start_time) / duration

        return calculate_level_at(pos, start_level, end_level, curve)
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

    private

    def shape_numbers
      curves.map { |curve| SHAPES.fetch(curve, curve || 5) }
    end

    def shape_values
      curves.map { 0 } # missing cases
    end

    def calculate_level_at(pos, start_level, end_level, curve)
      case curve
      when :step
        end_level

      when :hold
        start_level

      when :linear
        pos * (end_level - start_level) + start_level

      when :exponential
        start_level * (end_level / start_level).pow(pos)

      when :sine
        diff = (end_level - start_level)
        start_level + diff * (-Math.cos(Math::PI * pos) * 0.5 + 0.5)

      when :welch
        diff = (end_level - start_level)
        pi_div = Math::PI / 2

        if start_level < end_level
          start_level + diff * Math.sin(pi_div * pos)
        else
          end_level - diff * Math.sin(pi_div - pi_div * pos)
        end

      when :squared
        sqrt_start_level = Math.sqrt(start_level)
        diff = Math.sqrt(end_level) - sqrt_start_level

        (pos * diff + sqrt_start_level)**2

      when :cubed
        cbrt_start_level = start_level.pow(0.3333333)
        diff = end_level.pow(0.3333333) - cbrt_start_level

        (pos * diff + cbrt_start_level)**3

      else
        denom = 1.0 - Math.exp(curve)
        numer = 1.0 - Math.exp(pos * curve)

        start_level + (end_level - start_level) * (numer / denom)
      end
    end

    class << self
      def triangle(*args, **kwargs)
        params =
          positional_keyword_args(TRIANGLE_DEFAULTS, *args, **kwargs)

        dur = params[:dur]
        level = params[:level]

        new([ 0, level, 0 ], [ dur * 0.5, dur * 0.5 ])
      end

      def sine(*args, **kwargs)
        params = positional_keyword_args(SINE_DEFAULTS, *args, **kwargs)
        dur = params[:dur]
        level = params[:level]

        new([ 0, level, 0 ], [ dur * 0.5, dur * 0.5 ], curves: :sine)
      end

      def perc(*args, **kwargs)
        params = positional_keyword_args(PERC_DEFAULTS, *args, **kwargs)
        levels = [ 0, params[:level], 0 ]
        times = [ params[:attack], params[:release] ]

        new(levels, times, curves: params[:curves])
      end

      def linen(*args, **kwargs)
        params =
          positional_keyword_args(LINEN_DEFAULTS, *args, **kwargs)

        level = params[:level]
        levels = [ 0, level, level, 0 ]
        times = [ params[:attack], params[:sustain ], params[:release] ]

        new(levels, times, curves: params[:curves])
      end

      def step
      end

      def cutoff(*args, **kwargs)
        params =
          positional_keyword_args(CUTOFF_DEFAULTS, *args, **kwargs)

        # var releaseLevel = if(curveNo == 2) { -100.dbamp } { 0 };
        levels = [ params[:level], 0 ]
        times = [ params[:release] ]

        new(levels, times, curves: params[:curves], release_at: 0)
      end

      def dadsr(*args, **kwargs)
        params =
          positional_keyword_args(DADSR_DEFAULTS, *args, **kwargs)

        peak_level = params[:peak_level]
        sustain_level = params[:sustain_level]
        delay = params[:delay]
        attack = params[:attack]
        decay = params[:decay]
        release = params[:release]
        bias = params[:bias]
        curves = params[:curves]

        levels = [ 0, 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }

        times = [ delay, attack, decay, release ]

        new(levels, times, curves: curves, release_at: 3)
      end

      def adsr(*args, **kwargs)
        params =
          positional_keyword_args(ADSR_DEFAULTS, *args, **kwargs)

        peak_level = params[:peak_level]
        sustain_level = params[:sustain_level]
        attack = params[:attack]
        decay = params[:decay]
        release = params[:release]
        bias = params[:bias]
        curves = params[:curves]

        levels = [ 0, peak_level, peak_level * sustain_level, 0 ]
                   .map{ |e| e + bias }
        times = [ attack, decay, release ]

        new(levels: levels, times: times, curves: curves, release_at: 2)
      end

      def asr(*args, **kwargs)
        params =
          positional_keyword_args(ASR_DEFAULTS, *args, **kwargs)

        sustain_level = params[:sustain_level]
        attack = params[:attack]
        release = params[:release]

        levels = [ 0, sustain_level, 0 ]
        times = [ attack, release ]

        new(levels, times, curves: params[:curves], release_at: 1)
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
