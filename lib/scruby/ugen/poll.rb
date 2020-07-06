module Scruby
  module Ugen
    class Poll < Gen
      rates :control, :audio
      inputs trig: nil, input: nil, label: nil, trigid: -1
    end
  end
end
