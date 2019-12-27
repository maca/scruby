module Scruby
  module Ugen
    class AmpCompA < Base
      rates :control, :audio, :scalar
      inputs freq: 1000, root: 0, min_amp: 0.32, root_amp: 1
    end
  end
end
