module Scruby
  module Ugen
    class RecordBuf < Base
      rates :control, :audio
      inputs input_array: nil, bufnum: 0, offset: 0, rec_level: 1,
             pre_level: 0, run: 1, loop: 1, trigger: 1, done_action: 0
    end
  end
end
