module Scruby
  module Audio
    module Ugens
      class EnvGen < Ugen
        class << self
          def ar( envelope, gate = 1, levelScale = 1, levelBias = 0, timeScale = 1, doneAction = 0 )
            new(:audio, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array)
          end

          def kr( envelope, gate = 1, levelScale = 1, levelBias = 0, timeScale = 1, doneAction = 0 )
            new(:control, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array)
          end
          named_args_for :ar, :kr
        end
      end
    end
  end
end
