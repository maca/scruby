module Scruby
  module Audio
    class SynthDef
      attr_reader :name, :children, :constants, :control_names
      # Creates a new SynthDef instance 
      # An "ugen graph" block should be passed:
      #
      #   SynthDef.new('simple') do |rate|
      #     Out.ar( 0, SinOsc.ar(rate) )
      #   end
      #
      # Default values and rates for the block can be passed with the <tt>:values => []</tt> and <tt>:rates => []</tt> options:
      # E.g.
      #   SynthDef.new( :am, :values => [1, 1000, 10, 1] ) do |gate, portadora, moduladora, amp|
      #     modulacion = SinOsc.kr( moduladora, 0, 0.5, 0.5 )
      #     sig = SinOsc.ar( portadora, 0, modulacion )
      #     env = EnvGen.kr( Env.asr(2,1,2), gate, :doneAction => 2 )
      #     Out.ar( 0, sig*env*amp )
      #   end
      #
      # is equivalent to the Sclang SynthDef
      #   SynthDef(\am, {|gate=1, portadora=1000, moduladora=10, amp=1|
      #       var modulacion, sig, env;
      #       modulacion = SinOsc.kr(moduladora, 0, 0.5, 0.5);
      #       sig = SinOsc.ar(portadora, 0, modulacion);
      #       env = EnvGen.kr(Env.asr(2,1,2), gate, doneAction:2);
      #       Out.ar(0, sig*env*amp);
      #   }).send(s)
      #
      def initialize( name, options = {}, &block )
        @name, @children = name.to_s, []

        values = options.delete( :values ) || []
        rates  = options.delete( :rates )  || []
        block  = block || Proc.new{}

        @control_names = collect_control_names( block, values, rates )
        build_ugen_graph( block, @control_names )
        @constants = collect_constants( @children )
        
        @variants = [] #stub!!!
        
        warn( 'A SynthDef without a block is useless' ) unless block_given?
      end
      
      # Returns a string representing the encoded SynthDef in a way scsynth can interpret and generate.
      # This method is called by a server instance when sending the synthdef via OSC.
      #
      # For complex synthdefs the encoded synthdef can vary a little bit from what SClang would generate
      # but the results will be interpreted in the same way
      def encode
        controls = @control_names.reject { |cn| cn.non_control? }
        encoded_controls = [controls.size].pack('n') + controls.collect{ |c| c.name.encode + [c.index].pack('n') }.to_s
        
        init_stream + name.encode + constants.encode_floats + values.flatten.encode_floats + encoded_controls +
            [children.size].pack('n') + children.collect{ |u| u.encode }.join('') +
            [@variants.size].pack('n') #stub!!!
      end
      
      def init_stream(file_version = 1, number_of_synths = 1) #:nodoc:
        'SCgf' + [file_version].pack('N') + [number_of_synths].pack('n')
      end
      
      def values #:nodoc:
        @control_names.collect{ |control| control.value }
      end
      
      alias :send_msg :send
      # Sends itself to the given servers. One or more servers or an array of servers can be passed.
      # If no arguments are given the synthdef gets sent to all instantiated servers
      # E.g.
      #   s = Server.new('localhost', 5114)
      #   s.boot
      #   r = Server.new('127.1.1.2', 5114)
      #
      #   SynthDef.new('sdef'){ Out.ar(0, SinOsc.ar(220)) }.send(s)
      #   # this synthdef is only sent to s
      #
      #   SynthDef.new('sdef2'){ Out.ar(1, SinOsc.ar(222)) }.send
      #   # this synthdef is sent to both s and r
      #
      def send( *servers )
        servers = *servers
        (servers ? servers.to_array : Server.all).each{ |s| s.send_synth_def( self ) } 
        self
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

      def build_ugen_graph( function, control_names ) #:nodoc:
        Ugen.synthdef = self
        function.call *build_controls( control_names)
        Ugen.synthdef = nil
      end
      
      def collect_constants( children ) #:nodoc:
        children.send( :collect_constants ).flatten.compact.uniq
      end
      
    end
  end
end