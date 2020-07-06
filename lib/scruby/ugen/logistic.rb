module Scruby
  module Ugen
    class Logistic < Gen
      rates :control, :audio
      inputs chaos_param: 3, freq: 1000, init: 0.5
    end
  end
end
