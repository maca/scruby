module Scruby
  module Ugen
    class Gen < Base
      class << self
        def ar(*args, **kwargs)
          build(:audio, *args, **kwargs)
        end
        alias audio ar

        def kr(*args, **kwargs)
          build(:control, *args, **kwargs)
        end
        alias control kr

        def ir(*args, **kwargs)
          build(:scalar, *args, **kwargs)
        end
        alias scalar ir

        private

        def build(rate, *args, **kwargs)
          defaults = self.defaults.merge(mul: 1, add: 0)
          params = positional_keyword_args(defaults, *args, **kwargs)
          mul, add = params.delete(:mul), params.delete(:add)
          ugen = new(rate: rate, **params)

          case [ mul, add ]
            in [ 1, 0 ] then ugen
            in [ 1, _ ] then ugen + add
            in [ _, 0 ] then ugen * mul
            in [ _, _ ]
              build_mul_add(ugen, rate, mul, add)
          end
        end

        def build_mul_add(ugen, rate, mul, add)
          MulAdd.new(ugen, mul, add, rate: rate)
        end
      end
    end
  end
end
