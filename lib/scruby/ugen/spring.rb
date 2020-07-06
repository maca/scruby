module Scruby
  module Ugen
    class Spring < Gen
      rates :control, :audio
      inputs input: 0, spring: 1, damp: 0
    end
  end
end
