module Scruby
  module Ugen
    class Out < Ugen::Base
      rates :control, :audio
      inputs bus: nil, channels_array: nil

      # @channels = []
      # def output_specs; []; end

      class << self
        def ar(bus, *inputs)
          new(rate: :audio, bus: bus, channels_array: inputs)
        end

        def kr(bus, *inputs)
          new(rate: :control, bus: bus, channels_array: inputs)
        end
      end
    end
  end
end
