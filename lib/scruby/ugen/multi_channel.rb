module Scruby
  module Ugen
    class MultiChannel
      include Equatable
      include Enumerable
      include Operations

      def initialize(ugens)
        @ugens = ugens.to_a
      end

      def each
        return enum_for(:each) unless block_given?
        @ugens.each { |u| yield u }
      end

      def rate
        index = ugens
          .map { |u| u.respond_to?(:rate) ? u.rate : :scalar }
          .map { |rate| Ugen::RATES.index(rate) }.max

        Ugen::RATES.fetch(index)
      end

      def zip(other)
        max_size = self.max_size(other)
        cycle.take(max_size).zip(other.cycle.take(max_size))
      end

      def max_size(other)
        [ self, other ].max_by(&:size).size
      end

      def to_a
        @ugens.dup
      end

      def size
        @ugens.size
      end

      private

      attr_reader :ugens

      def cast(collection)
        self.class.new collection
      end
    end
  end
end
