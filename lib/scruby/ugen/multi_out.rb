module Scruby
  module Ugen
    module MultiOut #:nodoc:
      def self.included(base)
        base.extend ClassMethods
      end

      def initialize(rate, channels, *inputs)
        super rate, *inputs
        @channels = Array === channels ? channels : (0...channels).map{ |i| OutputProxy.new rate, self, i }
        @channels = @channels.to_da
      end

      def output_specs
        channels.output_specs.flatten
      end

      module ClassMethods
        private

        def new(rate, channels, *inputs)
          instantiated = super
          Array === instantiated ? instantiated : instantiated.channels
        end
      end
    end
  end
end
