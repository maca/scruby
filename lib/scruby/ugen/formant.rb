module Scruby
  module Ugen
    class Formant < Base
      rates :audio
      inputs fundfreq: 440, formfreq: 1760, bwfreq: 880
    end
  end
end
