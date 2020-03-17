module Scruby
  module Ugen
    class ScopeOut2 < Base
      rates :control, :audio
      inputs input_array: nil, scope_num: 0, max_frames: 4096,
 scope_frames: nil
    end
  end
end
