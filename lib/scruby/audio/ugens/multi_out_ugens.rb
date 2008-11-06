module Scruby
  module Audio
    module Ugens 
      
      class OutputProxy < Ugen
        attr_reader :source, :control_name, :output_index
        
        def initialize( rate, source, name, output_index )
          super rate
          @source, @control_name, @output_index = source, name, output_index
        end
        
        def index 
          @source.index
        end
        
        def add_to_synthdef; end
      end
      
      class MultiOutUgen < Ugen
        def initialize( rate, *channels )
          @channels = channels
          super rate
        end
        
        def self.new( rate, *args )
          super( rate, *args ).channels.compact #returns the channels but gets instantiated
        end
        
        private     
        def output_specs
          channels.collect{ |output| output.send :output_specs }.flatten
        end
      end

      class Control < MultiOutUgen #:nodoc:
        def initialize( rate, *names )
          super rate, *names.collect_with_index{|n, i| OutputProxy.new rate, self, n, i }
        end
        
        def self.and_proxies_from( names )
          Control.new( names.first.rate, *names )
        end
      end
      
    end
  end
end
