module Scruby
  module Ugen
    class InTrig < Gen
      rates :control
      attributes channel_count: 1

      inputs bus: 0
    end
  end
end
