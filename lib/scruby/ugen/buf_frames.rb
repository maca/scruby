module Scruby
  module Ugen
    class BufFrames < Base
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
