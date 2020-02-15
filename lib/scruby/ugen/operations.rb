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

        def unary(name, index:, aliases: [])
          unary_indexes[name] = index

          define_method(name) do
            Operations.apply_unary(name, self)
          end

          OperationHelpers.define_method name do |operand|
            Operations.apply_unary(name, operand)
          end

          aliases.each do |name_alias|
            define_method(name_alias) { send(name) }

            OperationHelpers.define_method name_alias do |operand|
              send(name, operand)
            end
          end
        end

        def binary(name, index:, operator: nil, aliases: [])
          binary_indexes[name] = index

          define_method name do |input|
            Operations.apply_binary(name, self, input)
          end

          OperationHelpers.define_method name do |left, right|
            Operations.apply_binary(name, left, right)
          end

          define_method(operator) { |i| send(name, i) } if operator

          aliases.each do |name_alias|
            define_method name_alias do |input|
              send(name, input)
            end

            OperationHelpers.define_method name_alias do |left, right|
              send(name, left, right)
            end
          end
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
          index = [ rate(left), rate(right) ]
                    .map { |rate| Ugen::RATES.index(rate) }.max

          Ugen::RATES.fetch(index)
        end

        def rate(operand)
          return operand.rate if operand.respond_to?(:rate)
          :scalar
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
      unary :midicps, index: 17, aliases: [ :midi_cps ]
      unary :cpsmidi, index: 18, aliases: [ :cps_midi ]
      unary :midiratio, index: 19, aliases: [ :midi_ration ]
      unary :ratiomidi, index: 20, aliases: [ :ratio_midi ]
      unary :dbamp, index: 21, aliases: [ :db_amp ]
      unary :ampdb, index: 22, aliases: [ :amp_dpb ]
      unary :octcps, index: 23, aliases: [ :oct_cps ]
      unary :cpsoct, index: 24, aliases: [ :cps_oct ]
      unary :rand, index: 37
      unary :rand2, index: 38
      unary :linrand, index: 39, aliases: [ :lind_rand ]
      unary :bilinrand, index: 40, aliases: [ :biling_rand ]
      unary :sum3rand, index: 41, aliases: [ :sum_3_rand ]
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
      unary :softclip, index: 43, aliases: [ :soft_clip ]

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
      binary :hypotApx, index: 24, aliases: [ :hypot_apx, :hypotapx ]
      binary :atan2, index: 22
      binary :ring1, index: 30
      binary :ring2, index: 31
      binary :ring3, index: 32
      binary :ring4, index: 33
      binary :sumsqr, index: 35, aliases: [ :sum_sqr ]
      binary :difsqr, index: 34, aliases: [ :diff_sqr ]
      binary :sqrsum, index: 36, aliases: [ :sqr_sum ]
      binary :sqrdif, index: 37, aliases: [ :sqr_dif ]
      binary :absdif, index: 38, aliases: [ :abs_dif ]
      binary :thresh, index: 39
      binary :amclip, index: 40
      binary :scaleneg, index: 41, aliases: [ :scale_neg ]
      binary :clip2, index: 42
      binary :wrap2, index: 45
      binary :fold2, index: 44
      binary :excess, index: 43


      # binary :moddif, index: -1, aliases: [:mod_dif]
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
