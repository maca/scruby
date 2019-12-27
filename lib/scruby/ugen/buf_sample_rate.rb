module Scruby
  module Ugen
    class BufSampleRate < Base
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
