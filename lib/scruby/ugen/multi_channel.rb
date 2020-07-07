module Scruby
  module Ugen
    class MultiChannel
      include Equatable
      include Enumerable
      include Operations

      def initialize(*ugens)
        @ugens = ugens.flatten
      end

      def each(&block)
        return enum_for(:each) unless block_given?
        @ugens.each { |u| yield u }
      end
    end
  end
end
