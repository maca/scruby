module Scruby
  module Audio
    module Ugens
      # This module enables Ugen operations for Ugens, Numeric and Arrays, when any instance of this classes executes an operation with an Ugen a BinaryUgenOp 
      # is instantiated where both objects are the inputs of the operation, an UnaryUgenOp is instantiated for unary operations
      # This are the permited operations:
      #
      # Binary: 
      # +, -, *, div, /, mod, <=, >=, minimum, maximum, lcm, gcd, round, roundUp, trunc, atan2, hypot, hypotApx, pow, leftShift, rightShift, unsignedRightShift, ring1, ring2, ring3, ring4, difsqr, sumsqr, sqrsum, sqrdif, absdif, thresh, amclip, scaleneg, clip2, excess, fold2, wrap2, rrand and exprand 
      # 
      # Unary:
      # neg, bitNot, abs, asFloat, ceil, floor, frac, sign, squared, cubed, sqrt, exp, reciprocal, midicps, cpsmidi, midiratio, ratiomidi, dbamp, ampdb, octcps, cpsoct, log, log2, log10, sin, cos, tam, asin, acos, atan, sinh, cosh, tanh, rand, rand2, linrand, bilinrand, sum3rand, distort, softclip, coin, rectWindow, hanWindow, welWindow, triWindow, ramp and scurve 
      # 
      module UgenOperations
        operation_indices = YAML::load File.open( File.dirname(__FILE__) + "/operation_indices.yaml" )
        UNARY      = operation_indices['unary']
        BINARY     = operation_indices['binary']      
        SAFE_NAMES = { :+ => :plus, :- => :minus, :* => :mult, :/ => :div2, :<= => :less_than_or_eql, :>= => :more_than_or_eql }
        
        def self.included klass
          klass.send :include, BinaryOperations
          klass.send :include, UnaryOperators if klass.ancestors.include? Ugen
        end
      
        module BinaryOperations
          BINARY.each_key do |op|
            method_name = SAFE_NAMES[op] || op
            define_method "__ugen_#{ method_name }" do |input|
              case input
              when Ugen
                BinaryOpUGen.new op, self, input
              when UgenOperations
                kind_of?( Ugen ) ? BinaryOpUGen.new( op, self, input ) : __send__( "__original_#{ method_name }", input )
              else
                raise ArgumentError.new( "Expected `#{ input.inspect }` to be a valid Ugen input" )
              end
            end
          end
          
          def self.included klass
            BINARY.each_key do |operator|
              safe_name = SAFE_NAMES[operator] || operator 
              klass.send( :alias_method, "__original_#{ safe_name }", operator ) rescue nil
              klass.send( :alias_method, operator, "__ugen_#{ safe_name }" )
            end
          end
        end
      
        module UnaryOperators
          UNARY.each_key{ |op| define_method(op){ UnaryOpUGen.new op, self } }
        end
      end
      
      [Ugen, ::Fixnum, ::Float, ::Array].each{ |k| k.send :include, UgenOperations }
    end
  end
end


