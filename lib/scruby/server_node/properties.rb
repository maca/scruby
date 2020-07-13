module Scruby
  module ServerNode
    class Properties
      attr_reader :name, :params

      def initialize(name, params)
        @name, @params = name, params
      end
    end
  end
end
