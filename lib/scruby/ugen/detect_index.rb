module Scruby
  module Ugen
    class DetectIndex < Base
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
