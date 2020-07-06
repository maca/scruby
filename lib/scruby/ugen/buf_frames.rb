module Scruby
  module Ugen
    class BufFrames < Gen
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
