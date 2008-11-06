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
        private     
        attr_writer :channels
        def output_specs
          channels.collect{ |output| output.send :output_specs }.flatten
        end
      end

      class Control < MultiOutUgen #:nodoc:
        def self.and_proxies_from( names )
          control = Control.new( names.first.rate )
          control.send :channels=, names.collect_with_index { |name, index| OutputProxy.new( names.first.rate, control, name, index ) }
        end
      end
      
    end
  end
end