module Scruby
  module Ugen
    RATES   = %i(scalar trigger demand control audio).freeze
    E_RATES = %i(scalar control audio demand).freeze

    class << self
      def max_rate(*args)
        MultiChannel.new([*args].flatten).rate
      end
    end
  end
end
