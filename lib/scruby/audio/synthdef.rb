module Scruby
  module Audio
    
    class SynthDef
      attr_accessor :name, :children, :constants, :control_names

      def initialize( name, options = {}, &function )
        @name, @children = name.to_s, []

        values = options.delete( :values ) || []
        rates  = options.delete( :rates )  || []
        function = function || Proc.new{}

        @control_names = collect_controls( function, values, rates )

        warn( 'A SynthDef without a block is useless' ) unless block_given?
      end

      def collect_controls( function, values, rates=[] ) #:nodoc:
        names = function.argument_names
        return [] if names.empty?
        names.zip( values, rates ).collect_with_index{ |array, index| ControlName.new *(array << index)  }
      end

      def build_ugen_graph( function ) #:nodoc:
        Ugen.synthdef = self
        function.call
        Ugen.synthdef = nil
      end
    end
    
  end
end