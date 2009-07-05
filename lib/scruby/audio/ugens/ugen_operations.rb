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
        operation_indices = YAML::load( File.open( "#{SCRUBY_DIR}/audio/ugens/operation_indices.yaml" ) )
        UNARY  = operation_indices['unary']
        BINARY = operation_indices['binary']      
        OP_SYMBOLS = { :+ => :plus, :- => :minus, :* => :mult, :/ => :div2, :<= => :less_than_or_eql, :>= => :more_than_or_eql }
        
        def valid_ugen_input?
          true
        end
        
        def self.included klass
          klass.send :include, BinaryOperations
          begin; klass.send( :include, UnaryOperators ) if klass.new.ugen?; rescue; end
        
          BINARY.each_key do |operator|
            override = OP_SYMBOLS[operator] || operator #can't name a method ugen_+ so use OP_SYMBOLS hash to get a 'safe' name
            begin; klass.send :alias_method, "original_#{override}", operator; rescue; end #if there is an original operator method make an alias with the prefix 'original' so it may be called latter
            klass.send :alias_method, operator, "ugen_#{override}" #alias the newly added operator method with the name of the operator( +, -, mod, etc...)
          end
        end
      
        module BinaryOperations
          BINARY.each_key do |op|
            method_name = OP_SYMBOLS[op] || op #get a 'safe' method name for the method to add
            eval "def ugen_#{method_name}( input )
                    return BinaryOpUGen.new(:#{op}, self, input) if input.ugen? or (self.kind_of?( Ugen ) and (input.kind_of?( Numeric ) or input.kind_of?( Array )))
                    return self.original_#{method_name}( input ) if self.respond_to?( :original_#{method_name} )
                    raise ArgumentError.new( %(Expected \#\{input\} to be an Ugen) )
                  end"          
          end
        end
      
        module UnaryOperators
          UNARY.each_key do |op|
            eval "def #{op}; UnaryOpUgen.new(:#{op}, self); end"
          end
        end
      end
    end
  end
end