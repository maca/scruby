module Scruby
  module Ugen
    class PartConv < Gen
      rates :audio
      inputs input: nil, fftsize: nil, irbufnum: nil
    end
  end
end
