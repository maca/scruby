module Scruby
  module Audio
    module Ugens

      class In < MultiOutUgen
        def self.ar( bus, num_channels = 1 )
          new :audio, num_channels, bus
        end
        
        def self.kr( bus, num_channels = 1 )
          new :control, num_channels, bus
        end
      end
      
      class AbstractOut 
      end
      
      class Out
        
        
      end
      
      
    end
  end
end