module Scruby
  module Ugens
    # This module enables Ugen operations for Ugens, Numeric and
    # Arrays, when any instance of this classes executes an operation
    # with an Ugen a BinaryUgenOp is instantiated where both objects
    # are the inputs of the operation, an UnaryUgenOp is instantiated
    # for unary operations This are the permited operations:
    #
    # Binary:
    #
    # +, -, *, div, /, mod, <=, >=, minimum, maximum, lcm, gcd, round,
    # roundUp, trunc, atan2, hypot, hypotApx, pow, leftShift,
    # rightShift, unsignedRightShift, ring1, ring2, ring3, ring4,
    # difsqr, sumsqr, sqrsum, sqrdif, absdif, thresh, amclip,
    # scaleneg, clip2, excess, fold2, wrap2, rrand and exprand
    #
    # Unary:
    #
    # neg, bitNot, abs, asFloat, ceil, floor, frac, sign, squared,
    # cubed, sqrt, exp, reciprocal, midicps, cpsmidi, midiratio,
    # ratiomidi, dbamp, ampdb, octcps, cpsoct, log, log2, log10, sin,
    # cos, tam, asin, acos, atan, sinh, cosh, tanh, rand, rand2,
    # linrand, bilinrand, sum3rand, distort, softclip, coin,
    # rectWindow, hanWindow, welWindow, triWindow, ramp and scurve
    #
    module UgenOperations
      indices = YAML.load File.open("#{__dir__}/operation_indices.yaml")

      UNARY      = indices["unary"]
      BINARY     = indices["binary"]
      SAFE_NAMES = {
        '+': :plus,
        '-': :minus,
        '*': :mult,
        '/': :div2,
        '<=': :less_than_or_eql,
        '>=': :more_than_or_eql
      }.freeze

      def self.included(base)
        # # Define unary operations
        # UNARY.each_key do |op|
        #   next if base.instance_methods.include?(op)

        #   define_method(op){ UnaryOpUGen.new(op, self) }
        # end

        # # Define binary operations
        # ugen_subclass = base.ancestors.include? Ugen

        # meth_def =
        #   if ugen_subclass
        #     proc do |_safe, op|
        #       proc{ |input| BinaryOpUGen.new(op, self, input) }
        #     end
        #   else
        #     proc do |safe, op|
        #       proc do |input|
        #         if input.is_a? Ugen
        #           BinaryOpUGen.new op, self, input
        #         else
        #           __send__ "__original_#{ safe }", input
        #         end
        #       end
        #     end
        #   end

        # BINARY.each_key do |op|
        #   safe = SAFE_NAMES[op]

        #   define_method "__ugenop_#{ safe || op }", &meth_def.call(safe || op, op)

        #   base.send :alias_method, "__original_#{ safe || op }", op unless ugen_subclass || !safe
        #   base.send :alias_method, op, "__ugenop_#{ safe || op }"
        # end
      end
    end

    [ Ugen, Integer, Float ].each{ |k| k.send :include, UgenOperations }
  end
end
