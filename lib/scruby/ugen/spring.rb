module Scruby
  module Ugen
    class Spring < Base
      rates :control, :audio
      inputs input: 0, spring: 1, damp: 0
    end
  end
end
