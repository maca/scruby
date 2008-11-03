module Scruby
  module Audio
    module Ugens

      class EnvGen < Ugen
        class << self
          def ar( envelope, gate = 1.0, levelScale = 1.0, levelBias = 0.0, timeScale = 1.0, doneAction = 0 )
            new(:audio, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array)
          end

          def kr( envelope, gate = 1.0, levelScale = 1.0, levelBias = 0.0, timeScale = 1.0, doneAction = 0 )
            new(:control, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array)
          end
        end
      end

      class Done < Ugen
        def self.kr( src )
          self.init( :control, src )
        end
      end

      class FreeSelf < Ugen
        def self.kr( input )
          self.init(:control, input)
          input
        end
      end

      class PauseSelf < Ugen
        def self.kr(input)
          self.init(:control, input)
          input
        end
      end

      class FreeSelfWhenDone < Ugen
        def self.kr(src)
          self.init(:control, src)
        end
      end

      class PauseSelfWhenDone < Ugen
        def self.kr(src)
          self.init(:control, src)
        end
      end

      class Pause < Ugen
        def self.kr(gate, id)
          self.init(:control, gate, id)
        end
      end

      class Free < Ugen
        def self.kr(trig, id)
          self.init(:control, trig, id)
        end
      end

      class Linen < Ugen
        class << self
          def kr( gate = 1.0, attackTime = 0.01, susLevel = 1.0, releaseTime = 1.0, doneAction = 0 )
            new( :control, gate, attackTime, susLevel, releaseTime, doneAction )
          end
          named_args_for :kr
        end
      end

    end
  end
end
