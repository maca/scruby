module Scruby
  module Ugens
    #
    # Default SuperCollider Ugens definitions are stored in the
    # ugen_defs.yml file and are defined as Ruby classes on the fly,
    # the yml format is:
    #
    #   NewUgen:
    #     :control:
    #     - - :input
    #       -
    #     - - :freq
    #       - 440
    #     :audio:
    #     - - :input
    #       -
    #     - - :freq
    #       - 440
    #
    # To define a Ruby class corresponding to an Ugen +name+ should be
    # passed and a hash of +rates+, inputs and default values, default
    # values can be nil
    #
    #   Ugens.define_ugen( 'NewUgen', {:control => [[:input, nil],
    #   [:freq, 440]], :audio => [[:input, nil], [:freq, 440]]} )
    #
    # The previous is equivalent as the following ruby code:
    #
    #   class NewUgen < Ugen
    #     class << self
    #       def kr( input, freq = 440 )
    #         new :control, input, freq
    #       end
    #
    #       def ar( input, freq = 440)
    #         new :audio, input, freq
    #       end
    #       # Makes possible passing args either in order or as
    #       # argument hash
    #       named_arguments_for :ar, :kr
    #     end
    #   end
    #
    # In future versions Ugen definitions will be loaded from ~/Ugens or ~/.Ugens directories either as yml files or rb files
    #
    def self.define_ugen(name, rates)
      rate_name = { audio: :ar, control: :kr, scalar: :ir, demand: :new }

      methods = rates.collect do |rate, args|
        if rate == :demand or rate == :scalar
          <<-RUBY_EVAL
            def new #{ args.collect{ |a, v| "#{ a } = #{ v.inspect }"  }.join(', ') }
              super #{ args.unshift([rate.inspect]).collect(&:first).join(', ') }
            end
          RUBY_EVAL
        else
          args ||= []
          args.push [:mul, 1], [:add, 0]
          args.uniq!
          assigns = []
          args.each_with_index do |arg, index|
            key, val = arg
            assigns << %{
              #{ key } = opts[:#{ key }] || args[#{ index }] || #{ val }
              raise( ArgumentError.new("`#{ key }` value must be provided") ) unless #{ key }
            }
          end

          new_args = [":#{ rate }"] + args[0...-2].collect(&:first)
          <<-RUBY_EVAL
          def #{ rate_name[rate] } *args
            raise ArgumentError.new("wrong number of arguments (\#{ args } for #{ args.size })") if args.size > #{args.size}
            opts = args.last.kind_of?( Hash ) ? args.pop : {}
            #{ assigns.join("\n") }
            new( #{ new_args.join(', ') } ).muladd( mul, add )
          end

          def params
            @params
          end
          RUBY_EVAL
        end
      end.join("\n")

      class_eval <<-RUBY_EVAL
      class #{ name } < Ugen
        @params = #{ rates.inspect }
        class << self
          #{ methods }
        end
      end
      RUBY_EVAL
      # # TODO: Load from ~/Ugens directory
    end

    YAML.load( File.open(  "#{__dir__}/ugen_defs.yaml" ) )
      .each_pair do |key, value|

      define_ugen key, value
    end
  end
end
