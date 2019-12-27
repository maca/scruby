module Scruby
  module Ugen
    class SpecPcile < Base
      rates :control
      inputs buffer: nil, fraction: 0.5, interpolate: 0
    end
  end
end
