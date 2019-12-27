module Scruby
  module Ugen
    class Poll < Base
      rates :control, :audio
      inputs trig: nil, input: nil, label: nil, trigid: -1
    end
  end
end
