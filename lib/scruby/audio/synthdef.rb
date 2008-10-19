module Scruby
  module Audio
    class SynthDef
      attr_accessor :name, :children, :constants, :control_names

      def initialize( name, options = {}, &block )
        @name, @children = name.to_s, []

        values = options.delete( :values ) || []
        rates  = options.delete( :rates )  || []
        block  = block || Proc.new{}

        @control_names = collect_control_names( block, values, rates )

        warn( 'A SynthDef without a block is useless' ) unless block_given?
      end

      def collect_control_names( function, values, rates=[] ) #:nodoc:
        return [] if (names = function.argument_names).empty?
        names.zip( values, rates ).collect_with_index{ |array, index| ControlName.new *(array << index)  }
      end
      
      def build_controls( control_names ) 
        
        arguments = []
        
        control_names_by_rate = [:scalar, :trigger, :control].collect do |rate| 
          control_names.select{ |control| control.rate == rate } 
        end
        
        for control_names in control_names_by_rate.reject{ |control_names| control_names.empty? }
        end
        
      end

      def build_ugen_graph( function ) #:nodoc:
        Ugen.synthdef = self
        function.call
        Ugen.synthdef = nil
      end
    end
    
  end
end