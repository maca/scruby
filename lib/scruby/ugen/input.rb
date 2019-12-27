# frozen_string_literal: true

module Scruby
  module Ugen
    class Input
      def initialize(value)
        @value = value
      end

      def ==(other)
        value == other.value
      end

      class << self
        def wrap(input)
          case input
          when ::Numeric
            Input::Numeric.new(input)
          when Base, Env, ControlName, Array
            input
          else
            raise ArgumentError, "Invalid Ugen input"
          end
        end
      end

      class Numeric < Input
        attr_accessor :value

        def rate; :scalar end

        def constants #:nodoc:
          self
        end

        def input_specs(graph)
          [ -1, graph.constants.index(value) ]
        end
      end
    end
  end
end
