module Scruby
  module Ugen
    class Out < Ugen::Base
      rates :control, :audio
      inputs bus: nil, channels_array: nil

      def output_specs; [] end
      def channels_count; 0 end

      def input_values
        super.flatten
      end
    end
  end
end
