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
      UgenGraph::ControlName.new(val, :control)
    end

    def scalar(val)
      UgenGraph::ControlName.new(val, :scalar)
    end

    def trigger(val)
      UgenGraph::ControlName.new(val, :trigger)
    end
  end
end
