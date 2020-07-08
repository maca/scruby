module Scruby
  module Ugen
    class BinaryOpUgen < Operation
      attributes operation: nil
      inputs left: nil, right: nil

      class << self
        def apply(operation, left, right)
          rate = Ugen.max_rate(left, right)

          return optimize_add(rate, left, right) if operation == :add
          new(operation, left, right, rate: rate)
        end

        private

        def optimize_add(rate, left, right)
          ary = MultiChannel.new([ *left ])
                  .zip([ *right ])
                  .map { |a, b| optimize(rate, a, b) }

          ary.size == 1 ? ary.first : MultiChannel.new(ary)
        end

        def optimize(rate, left, right)
          if [ mul?(left), mul?(right) ].any?
            mul_add(rate, left, right)
          else
            new(:add, left, right, rate: rate)
          end
        end

        def mul_add(rate, one, other)
          if mul?(one)
            MulAdd.new(one.left, one.right, other, rate: rate)
          else
            MulAdd.new(other.left, other.right, one, rate: rate)
          end
        end

        def mul?(ugen)
          BinaryOpUgen === ugen && ugen.operation == :mul
        end
      end
    end
  end
end
