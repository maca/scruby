module Scruby
  module Ugen
    class BufSamples < Base
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
