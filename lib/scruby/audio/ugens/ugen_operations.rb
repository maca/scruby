module Scruby
  module Audio
    module Ugens
      module UgenOperations
        operation_indices = YAML::load( File.open( "#{SCRUBY_DIR}/audio/ugens/operation_indices.yaml" ) )
        UNARY  = operation_indices['unary']
        BINARY = operation_indices['binary']      
        OP_SYMBOLS = { :+ => :plus, :- => :minus, :* => :mult, :/ => :div2, :<= => :less_than_or_eql, :>= => :more_than_or_eql }
        
        def valid_ugen_input?
          true
        end
        
        def self.included( klass )
          klass.send( :include, BinaryOperations )
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
                    return BinaryOpUGen.new(:#{op}, self, input) if input.ugen?
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