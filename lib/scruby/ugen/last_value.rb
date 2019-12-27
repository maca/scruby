module Scruby
  module Ugen
    class LastValue < Base
      rates :control, :audio
      inputs input: 0, diff: 0.01
    end
  end
end
