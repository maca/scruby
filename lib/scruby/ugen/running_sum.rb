module Scruby
  module Ugen
    class RunningSum < Base
      rates :control, :audio
      inputs input: nil, numsamp: 40
    end
  end
end
