module Scruby
  module Ugen
    class Fold < Gen
      rates :control, :audio, :scalar
      inputs input: 0, lo: 0, hi: 1
    end
  end
end
