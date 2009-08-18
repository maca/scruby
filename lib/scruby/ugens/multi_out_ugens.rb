module Scruby
  module Ugens 
    module MultiOut #:nodoc:
      def self.included base
        base.extend ClassMethods
      end
      
      def initialize rate, channels, *inputs
        super rate, *inputs
        @channels = Array === channels ? channels : (0...channels).map{ |i| OutputProxy.new rate, self, i }
      end
      
      private     
      def output_specs
        channels.collect{ |output| output.send :output_specs }.flatten
      end
      
      module ClassMethods
        def new *args
          super.channels #returns the channels but gets instantiated, TODO: Maybe not a good idea
        end
      end
    end
    
    class OutputProxy < Ugen #:nodoc:
      attr_reader :source, :control_name, :output_index
      class << self; public :new; end

      def initialize rate, source, output_index, name = nil
        super rate
        @source, @control_name, @output_index = source, name, output_index
      end

      def index; @source.index; end

      def add_to_synthdef; end
      
    end

    class Control < Ugen #:nodoc:
      include MultiOut
      
      def initialize rate, *names
        super rate, names.collect_with_index{ |n, i| OutputProxy.new rate, self, i, n }
      end
      
      def self.and_proxies_from names
        new names.first.rate, *names
      end
    end
  end
end
