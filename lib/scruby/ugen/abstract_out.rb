module Scruby
  module Ugen
    class AbstractOut < Ugen::Base
      def output_specs; [] end
      def channel_count; 0 end

      def input_values
        super.flatten
      end

      def parameter_names
        super - %i(channels_array)
      end

      def out?
        true
      end

      class << self
        def ar(*args, **kwargs)
          build(:audio, *args, **kwargs)
        end
        alias audio ar
      end
    end
  end
end
