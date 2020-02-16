module Scruby
  module Ugen
    class Control < Base
      rates :scalar, :control, :trigger
      attributes control_names: []

      def output_specs
        control_names.map(&:rate_index)
      end

      def channels_count
        control_names.count
      end
    end
  end
end
