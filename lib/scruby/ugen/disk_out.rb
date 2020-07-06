module Scruby
  module Ugen
    class DiskOut < Gen
      rates :audio
      inputs bufnum: nil, channels_array: nil
    end
  end
end
