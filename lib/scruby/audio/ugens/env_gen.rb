module Scruby
  module Audio
    module Ugens
      class EnvGen < Ugen
        class << self
          # New EnvGen with :audio rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def ar envelope, gate = 1, levelScale = 1, levelBias = 0, timeScale = 1, doneAction = 0
            new :audio, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array
          end
          # New EnvGen with :control rate, inputs should be valid Ugen inputs or Ugens, arguments can be passed as an options hash or in the given order
          def kr envelope, gate = 1, levelScale = 1, levelBias = 0, timeScale = 1, doneAction = 0
            new :control, gate, levelScale, levelBias, timeScale, doneAction, *envelope.to_array
          end
          
          named_arguments_for :ar, :kr
          
          private
          def new *args; super; end
        end
      end
    end
  end
end
