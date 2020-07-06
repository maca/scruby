module Scruby
  module Ugen
    class AmpComp < Gen
      rates :control, :audio, :scalar
      inputs freq: nil, root: nil, exp: 0.3333
    end
  end
end
