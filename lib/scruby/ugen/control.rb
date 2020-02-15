module Scruby
  module Ugen
    class Control < Base
      rates :scalar, :control, :trigger
      inputs control_names: []

      def output_specs
        control_names.map(&:rate_index)
      end

      def channels_count
        control_names.count
      end

      def inputs
        {}
      end
    end
  end
end
