module Scruby
  module Audio
    module Ugens 

      class OutputProxy < Ugen #:nodoc:
        attr_reader :source, :control_name, :output_index
        
        def initialize rate, source, output_index, name = nil
          super rate
          @source, @control_name, @output_index = source, name, output_index
        end
        
        def index 
          @source.index
        end
        
        def add_to_synthdef; end
      end
      
      class MultiOutUgen < Ugen #:nodoc:
        def initialize rate, *channels
          super rate
          @channels = channels
        end
        
        def self.new rate, *args
          super.channels #returns the channels but gets instantiated
        end
        
        private     
        def output_specs
          channels.collect{ |output| output.send :output_specs }.flatten
        end
      end

      class Control < MultiOutUgen #:nodoc:
        def initialize rate, *names
          super rate, *names.collect_with_index{|n, i| OutputProxy.new rate, self, i, n }
        end
        
        def self.and_proxies_from names
          new names.first.rate, *names
        end
      end
      
    end
  end
end
