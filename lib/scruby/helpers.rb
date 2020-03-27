module Scruby
  module Helpers
    class << self
      def included(base)
        base.include Scruby
        base.include Ugen
        base.include Ugen::Operations::OperationHelpers
      end
    end

    def control(val)
      Graph::ControlName.new(val, :control)
    end

    def scalar(val)
      Graph::ControlName.new(val, :scalar)
    end

    def trigger(val)
      Graph::ControlName.new(val, :trigger)
    end
  end
end
