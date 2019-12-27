module Scruby
  module Ugen
    class PartConv < Base
      rates :audio
      inputs input: nil, fftsize: nil, irbufnum: nil
    end
  end
end
