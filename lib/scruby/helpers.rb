module Scruby
  module Helpers
    class << self
      def included(base)
        base.include Scruby
        base.include Ugen
        base.include Ugen::Operations::OperationHelpers
      end
    end

    def kr(val)
      Graph::ControlName.new(val, :control)
    end

    def ir(val)
      Graph::ControlName.new(val, :scalar)
    end

    def tr(val)
      Graph::ControlName.new(val, :trigger)
    end
  end
end
