module Scruby
  module Audio
    module Ugens 
      class OutputProxy < Ugen
        attr_reader :source, :control_name, :output_index
        
        def initialize( rate, source, name, output_index )
          super(rate)
          @source, @index = source, source.index
          @control_name, @output_index = name, output_index
        end
        
        def add_to_synthdef; end
        
      end
      
      class MultiOutUgen < Ugen
        attr_reader :channels, :outputs
        private              
        attr_writer :channels, :outputs
        
        def output_specs
          outputs.collect{ |output| output.send :output_specs }.flatten
        end
        
      end

      class Control < MultiOutUgen #:nodoc:
        def self.and_proxies_from( names )
          control = Control.new( names.first.rate )
          control.send :outputs=, names.collect_with_index { |name, index| OutputProxy.new( names.first.rate, control, name, index ) }
        end
        
        def initialize(rate, *inputs)
          super
        end

      end
    end
  end
end