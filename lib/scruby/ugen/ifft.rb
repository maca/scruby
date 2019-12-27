module Scruby
  module Ugen
    class IFFT < Base
      rates :control, :audio
      inputs buffer: nil, wintype: 0, winsize: 0
    end
  end
end
