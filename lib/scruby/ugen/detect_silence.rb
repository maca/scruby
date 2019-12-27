module Scruby
  module Ugen
    class DetectSilence < Base
      rates :control, :audio
      inputs input: 0, amp: 0.0001, time: 0.1, done_action: 0
    end
  end
end
