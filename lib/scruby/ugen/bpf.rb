module Scruby
  module Ugen
    class BPF < Base
      rates :control, :audio
      inputs input: 0, freq: 440, rq: 1
    end
  end
end
