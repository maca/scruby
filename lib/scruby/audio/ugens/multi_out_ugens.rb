module Scruby
  module Audio
    module Ugens
      class OutputProxy
        attr_reader :source, :control_name, :output_index
        
        def initialize( source, control_name, index)
          @source, @control_name, @output_index = source, control_name, index
        end
      end
      
      class MultiOutUgen < Ugen
        attr_reader :channels, :outputs
        private 
        attr_writer :channels, :outputs
      end
      
      class Control < MultiOutUgen #:nodoc:
        def self.and_proxies_from( names )
          control = Control.new( names.first.rate )
          control.send :outputs=, names.collect_with_index { |name, index| OutputProxy.new( control, name, index ) }
        end
        
        def self.new( rate )
          control = super( rate, [])
        end
      end
    end
  end
end