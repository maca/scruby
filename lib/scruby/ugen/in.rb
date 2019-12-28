module Scruby
  module Ugen
    class In < Ugen::Base
      include MultiOut

      class << self
        def ar(bus, channels = 1)
          new :audio, channels, bus
        end

        def kr(bus, channels = 1)
          new :control, channels, bus
        end
      end
    end
  end
end
