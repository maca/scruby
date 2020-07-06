module Scruby
  module Ugen
    class PSinGrain < Gen
      rates :audio
      inputs freq: 440, dur: 0.2, amp: 0.1
    end
  end
end
