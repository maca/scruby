module Scruby
  module Ugen
    class FFT < Gen
      rates nil
      inputs buffer: nil, input: 0, hop: 0.5, wintype: 0, active: 1,
             winsize: 0
    end
  end
end
