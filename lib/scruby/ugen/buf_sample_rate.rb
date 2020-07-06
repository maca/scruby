module Scruby
  module Ugen
    class BufSampleRate < Gen
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
