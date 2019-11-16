module Scruby
  module Ugens
    # Done Actions:
    #
    # * 0   do nothing when the UGen is finished
    # * 1   pause the enclosing synth, but do not free it
    # * 2   free the enclosing synth
    # * 3   free both this synth and the preceding node
    # * 4   free both this synth and the following node
    # * 5   free this synth; if the preceding node is a group
    #       then do g_freeAll on it, else free it
    # * 6   free this synth; if the following node is a group
    #       then do g_freeAll on it, else free it
    # * 7   free this synth and all preceding nodes in this group
    # * 8   free this synth and all following nodes in this group
    # * 9   free this synth and pause the preceding node
    # * 10  free this synth and pause the following node
    # * 11  free this synth and if the preceding node is a group
    #       then do g_deepFree on it, else free it
    # * 12  free this synth and if the following node is a group
    #       then do g_deepFree on it, else free it
    # * 13  free this synth and all other nodes in this group
    #       (before and after)
    # * 14  free the enclosing group and all nodes within it
    #       (including this synth)
    class EnvGen < Ugen
      class << self
        # New EnvGen with :audio rate, inputs should be valid Ugen
        # inputs or Ugens, arguments can be passed as an options hash
        # or in the given order
        def ar(envelope, gate: 1, levelScale: 1, levelBias: 0,
               timeScale: 1, doneAction: 0)

          new :audio, gate, levelScale, levelBias, timeScale,
              doneAction, *envelope.to_array
        end

        # New EnvGen with :control rate, inputs should be valid Ugen
        # inputs or Ugens, arguments can be passed as an options hash
        # or in the given order
        def kr(envelope, gate: 1, levelScale: 1, levelBias: 0,
               timeScale: 1, doneAction: 0)

          new :control, gate, levelScale, levelBias, timeScale,
              doneAction, *envelope.to_array
        end

        private

        def new(*args); super; end
      end
    end
  end
end
