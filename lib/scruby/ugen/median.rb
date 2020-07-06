module Scruby
  module Ugen
    class Median < Gen
      rates :control, :audio
      inputs length: 3, input: 0
    end
  end
end
