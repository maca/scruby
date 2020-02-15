module Scruby
  module Ugen
    module Operations
      OperationHelpers = Module.new

      class << self
        def unary_indexes
          @unary_indexes ||= {}
        end

        def binary_indexes
          @binary_indexes ||= {}
        end

        def operations
          unary_indexes.keys + binary_indexes.keys
        end

        def unary(name, index: )
          unary_indexes[name] = index

          define_method(name) do
            Operations.apply_unary(name, self)
          end

          OperationHelpers.define_method name do |operand|
            Operations.apply_unary(name, operand)
          end
        end

        def binary(name, index: , operator: nil)
          binary_indexes[name] = index

          define_method name do |input|
            Operations.apply_binary(name, self, input)
          end

          OperationHelpers.define_method name do |left, right|
            Operations.apply_binary(name, left, right)
          end

          define_method(operator) { |i| send(name, i) } if operator
        end

        def apply_unary(name, operand)
          UnaryOpUgen.new(
            rate: operand.rate,
            operation: name,
            operand: operand
          )
        end

        def apply_binary(name, left, right)
          BinaryOpUgen.new(
            rate: max_rate(left, right),
            operation: name,
            left: left,
            right: right
          )
        end

        private

        def max_rate(left, right)
          index = [ left.rate, right.rate ]
                    .map { |rate| Ugen::RATES.index(rate) }.max

          Ugen::RATES.fetch(index)
        end
      end

      unary :neg, index: 0
      unary :reciprocal, index: 16
      unary :abs, index: 5
      unary :floor, index: 9
      unary :ceil, index: 8
      unary :frac, index: 10
      unary :sign, index: 11
      unary :squared, index: 12
      unary :cubed, index: 13
      unary :sqrt, index: 14
      unary :exp, index: 15
      unary :midicps, index: 17
      unary :cpsmidi, index: 18
      unary :midiratio, index: 19
      unary :ratiomidi, index: 20
      unary :dbamp, index: 21
      unary :ampdb, index: 22
      unary :octcps, index: 23
      unary :cpsoct, index: 24
      unary :rand, index: 37
      unary :rand2, index: 38
      unary :linrand, index: 39
      unary :bilinrand, index: 40
      unary :sum3rand, index: 41
      unary :coin, index: 44
      unary :log, index: 25
      unary :log2, index: 26
      unary :log10, index: 27
      unary :sin, index: 28
      unary :cos, index: 29
      unary :tan, index: 30
      unary :asin, index: 31
      unary :acos, index: 32
      unary :atan, index: 33
      unary :sinh, index: 34
      unary :cosh, index: 35
      unary :tanh, index: 36
      unary :distort, index: 42
      unary :softclip, index: 43

      binary :add, index: 0, operator: :+
      binary :sub, index: 1, operator: :-
      binary :mul, index: 2, operator: :*
      binary :div, index: 4, operator: :/
      binary :pow, index: 25
      binary :lcm, index: 17
      binary :gcd, index: 18
      binary :less_than, index: 8, operator: :<
      binary :less_or_eq, index: 10, operator: :<=
      binary :more_than, index: 9, operator: :>
      binary :more_or_eq, index: 11, operator: :>=
      binary :eq, index: 6
      binary :not_eq, index: 7
      binary :min, index: 12
      binary :max, index: 13
      binary :round, index: 19
      binary :trunc, index: 21
      binary :hypot, index: 23
      binary :hypotApx, index: 24
      binary :atan2, index: 22
      binary :ring1, index: 30
      binary :ring2, index: 31
      binary :ring3, index: 32
      binary :ring4, index: 33
      binary :sumsqr, index: 35
      binary :difsqr, index: 34
      binary :sqrsum, index: 36
      binary :sqrdif, index: 37
      binary :absdif, index: 38
      binary :moddif, index: -1
      binary :thresh, index: 39
      binary :amclip, index: 40
      binary :scaleneg, index: 41
      binary :clip2, index: 42
      binary :wrap2, index: 45
      binary :fold2, index: 44
      binary :excess, index: 43


      # unary :is_positive, index: -1
      # unary :is_negative, index: -1
      # unary :is_strictly_positive, index: -1

      # binary :%, index: -1
      # binary :**, index: -1
      # binary :<!, index: -1

      # def muladd(mul, add)
      #   MulAdd.new(self, mul, add)
      # end
    end
  end
end
