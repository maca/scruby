module Scruby
  module Ugen
    class BufSamples < Gen
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
