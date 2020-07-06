module Scruby
  module Ugen
    class LastValue < Gen
      rates :control, :audio
      inputs input: 0, diff: 0.01
    end
  end
end
