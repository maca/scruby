module Scruby
  module Ugen
    class DetectIndex < Gen
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
