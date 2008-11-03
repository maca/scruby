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
        
        @variants = [] #stub!!
        
        warn( 'A SynthDef without a block is useless' ) unless block_given?
      end
      
      #Sending
      def encode
        controls = @control_names.reject { |cn| cn.non_control? }
        encoded_controls = [controls.size].pack('n') + controls.collect{ |c| c.name.encode + [c].index.pack('n') }.to_s
        
        init_stream + name.encode + constants.encode_floats + values.flatten.encode_floats + encoded_controls +
            [children.size].pack('n') + children.collect{ |u| u.encode }.join('') +
            [@variants.size].pack('n') #stub!!!
      end
      
      def init_stream(file_version = 1, number_of_synths = 1) #:nodoc:
        'SCgf' + [file_version].pack('N') + [number_of_synths].pack('n')
      end
      
      def values
        @control_names.collect{ |control| control.value }
      end
      
      private
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