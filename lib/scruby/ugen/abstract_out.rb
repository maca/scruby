module Scruby
  module Ugen
    module AbstractOut
      def output_specs; [] end
      def channels_count; 0 end

      def input_values
        super.flatten
      end

      def out?
        true
      end
    end
  end
end
