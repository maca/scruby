module Scruby
  module Audio
    module Ugens

      class In < MultiOutUgen
        def initialize rate, channels, bus #:nodoc:
          super rate, *(0...channels).map{ |i| OutputProxy.new rate, self, i }
          @inputs = [bus]
        end
                
        class << self
          # New In with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def ar bus, channels = 1
            new :audio, channels, bus
          end
          # New In with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def kr bus, num_channels = 1
            new :control, channels, bus
          end
          
          private
          def new *args; super; end
        end
      end

      class Out < Ugen
        # ar and kr should be use for instantiatio
        def initialize *args
          super
          @channels = []
        end
        
        def output_specs #:nodoc:
          []
        end
        class << self
          # New Out with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def ar bus, *inputs
            inputs = *inputs
            new :audio, bus, *inputs; 0.0 #Out has no output
          end

          # New Out with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def kr bus, *inputs
            inputs = *inputs
            new :control, bus, *inputs; 0.0 #Out has no output
          end
          
          private
          def new *args; super; end
        end
      end
      
    end
  end
end