module Scruby
  module Ugen
    class SpecPcile < Gen
      rates :control
      inputs buffer: nil, fraction: 0.5, interpolate: 0
    end
  end
end
