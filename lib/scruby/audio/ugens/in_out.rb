module Scruby
  module Audio
    module Ugens

      class In < MultiOutUgen
        def initialize( rate, channels, bus ) #:nodoc:
          super rate, *(0...channels).map{ |i| OutputProxy.new rate, self, i }
          @inputs = [bus]
        end
        
        def self.ar( bus, channels = 1 )
          new :audio, channels, bus
        end
        
        def self.kr( bus, num_channels = 1 )
          new :control, channels, bus
        end
      end

      class Out < Ugen
        def initialize(*args) #:nodoc:
          super
          @channels = []
        end

        def self.ar (  bus, *inputs )
          inputs = *inputs
          new :audio, bus, *inputs; 0.0    #Out has no output
        end

        def self.kr (  bus, *inputs )
          inputs = *inputs
          new :control, bus, *inputs; 0.0  #Out has no output
        end

        def output_specs
          []
        end
      end
      
    end
  end
end