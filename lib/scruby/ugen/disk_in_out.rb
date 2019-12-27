# frozen_string_literal: true

module Scruby
  module Ugen
    class DiskOut < Ugen::Base
      def output_specs; []; end
      def channels; []; end

      class << self
        def ar(bufnum, *inputs)
          inputs.peel!
          new :audio, bufnum, *inputs
          0.0
        end
      end
    end

    class DiskIn < Ugen::Base
      include MultiOut

      def self.ar(channels, bufnum, loop: 0)
        new :audio, channels, bufnum, loop
      end
    end

    class VDiskIn < Ugen::Base
      include MultiOut

      class << self
        def ar(channels, bufnum, rate: 1, loop: 0, send_id: 0)
          new :audio, channels, bufnum, rate, loop, send_id
        end
      end
    end
  end
end
