module Scruby
  module Audio
    module Ugens

      class In < MultiOutUgen
        #:nodoc:
        def initialize rate, channels, bus 
          super rate, *(0...channels).map{ |i| OutputProxy.new rate, self, i }
          @inputs = [bus]
        end
                
        class << self
          # New In with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def ar bus, channels = 1
            new :audio, channels, bus
          end
          # New In with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def kr bus, channels = 1
            new :control, channels, bus
          end
          
          def params #:nodoc:
            {:audio => [[:bus, nil], [:channels, 1], [:mul, 1], [:add, 0]], :control => [[:bus, nil], [:channels, 1], [:mul, 1], [:add, 0]]}
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
        
        #:nodoc:
        def output_specs; []; end
        
        class << self
          # New Out with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def ar bus, *inputs
            inputs.peel!
            new :audio, bus, *inputs; 0.0 #Out has no output
          end

          # New Out with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def kr bus, *inputs
            inputs.peel!
            new :control, bus, *inputs; 0.0 #Out has no output
          end
          
          
          def params #:nodoc:
            {:audio => [[:bus,nil], [:inputs, []], [:mul, 1], [:add, 0]], :control => [[:bus,nil], [:inputs, []], [:mul, 1], [:add, 0]]}
          end
          
          private
          def new *args; super; end
        end
      end
      
    end
  end
end