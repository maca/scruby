module Scruby
  module Attributes
    class AttributeMap
      attr_reader :attributes

      def initialize(&block)
        @attributes = {}
        instance_eval(&block)
      end

      def attribute(name, value = nil)
        attributes.merge!(name.to_s => value)
      end
    end

    def attributes(&block)
      defaults = AttributeMap.new(&block).attributes

      dynamic_module =
        Module.new do
          attr_accessor *defaults.keys

          define_method :initialize do |**attrs|
            defaults.merge(attrs).each do |k, v|
              unless defaults.keys.include?(k.to_s)
                raise ArgumentError, "(unknown keyword: #{k})"
              end

              public_send("#{k}=", v)
            end
          end

          define_method :attributes do
            defaults.keys
              .map { |attr| [ attr, public_send(attr) ] }.to_h
          end
        end

      include dynamic_module
    end
  end
end
