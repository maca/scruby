module Scruby
  module Audio
    class SynthDef
      attr_reader :name, :children, :constants, :control_names

      def initialize( name, options = {}, &block )
        @name, @children = name.to_s, []

        values = options.delete( :values ) || []
        rates  = options.delete( :rates )  || []
        block  = block || Proc.new{}

        @control_names = collect_control_names( block, values, rates )
        build_ugen_graph( block, @control_names )
        @constants = collect_constants( @children )

        warn( 'A SynthDef without a block is useless' ) unless block_given?
      end
      
      private
      attr_writer :name, :children, :constants, :control_names

      def collect_control_names( function, values, rates ) #:nodoc:
        return [] if (names = function.argument_names).empty?
        names.zip( values, rates ).collect_with_index{ |array, index| ControlName.new *(array << index)  }
      end
      
      def build_controls( control_names ) #:nodoc:
        # control_names.select{ |c| c.rate == :noncontrol }.sort_by{ |c| c.control_name.index } + 
        [:scalar, :trigger, :control].collect do |rate| 
          same_rate_array = control_names.select{ |control| control.rate == rate }
          Control.and_proxies_from( same_rate_array ) unless same_rate_array.empty?
        end.flatten.compact.sort_by{ |proxy| proxy.control_name.index }
      end

      def build_ugen_graph( function, output_proxies ) #:nodoc:
        Ugen.synthdef = self
        function.call output_proxies
        Ugen.synthdef = nil
      end
      
      def collect_constants( children ) #:nodoc:
        children.send( :collect_constants ).flatten.uniq
      end
    end
  end
end