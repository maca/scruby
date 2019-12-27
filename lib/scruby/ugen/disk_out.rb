module Scruby
  module Ugen
    class DiskOut < Base
      rates :audio
      inputs bufnum: nil, channels_array: nil
    end
  end
end
