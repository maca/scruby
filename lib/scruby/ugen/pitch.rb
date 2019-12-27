module Scruby
  module Ugen
    class Pitch < Base
      rates :control
      inputs input: 0, init_freq: 440, min_freq: 60, max_freq: 4000, exec_freq: 100, max_bins_per_octave: 16, median: 1, amp_threshold: 0.01, peak_threshold: 0.5, down_sample: 1, clar: 0
    end
  end
end
