module Scruby
  module Utils
    module PositionalKeywordArgs
      private

      def positional_keyword_args(defaults, *args, **kwargs)
        if args.size > defaults.size
          raise ArgumentError, %W[
            (wrong number of arguments (given #{args.size},
            expected less than #{defaults.size}))
          ].join(" ")
        end

        extra_keys = kwargs.keys - defaults.keys
        if extra_keys.any?
          sust = "keyword#{ extra_keys.size > 1 ? 's' : '' }"
          keys = extra_keys.map(&:inspect).join(", ")
          raise ArgumentError, "(unknown #{sust}: #{keys})"
        end

        names = defaults.keys
        positional_args = names[0...args.size].zip(args)

        (defaults.to_a + positional_args + kwargs.to_a).to_h
      end
    end
  end
end
