module Scruby
  module Utils
    module PositionalKeywordArgs
      def positional_keyword_args(defaults, *args, **kwargs)
        names = defaults.keys
        positional_args = names[0...args.size].zip(args)

        (defaults.to_a + positional_args + kwargs.to_a).to_h
      end
    end
  end
end
