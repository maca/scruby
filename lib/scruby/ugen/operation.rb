module Scruby
  module Ugen
    class Operation < Base
      def special_index
        Operations.binary_indexes.fetch(operation)
      end

      def parameter_names
        []
      end

      def print_name
        operation
      end

      class << self
        def inherited(base)
          base.rates Scruby::Ugen::RATES
        end
      end
    end
  end
end
