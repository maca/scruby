module Scruby
  module Ugen
    class Graph
      include Encode

      attr_reader :name, :root, :nodes, :controls, :constants

      def initialize(root, name: nil, controls: {})
        @name = name
        @controls = controls.transform_values &method(:build_control)
        @nodes = [
          (ControlNode.new(controls) unless controls.size.zero?)
        ].compact
        @constants = []

        @root = Node.new(root, self)
      end

      def add(node)
        @nodes.push node
      end

      def add_constant(const)
        @constants.push const
      end

      def encode
        [ "SCgf",
          encode_int32(2), # file version
          encode_int16(1), # number of defs
          encode_string(name),
          encode_constants,
          encode_control_defaults,
          encode_control_names,
          encode_nodes,
          encode_variants
        ].join
      end

      private

      def build_control(val)
        return val if val.is_a?(Control)
        Control.new(val)
      end

      def encode_constants
        encode_floats_array constants.map(&:value)
      end

      def encode_control_defaults
        encode_floats_array controls.values.map(&:default)
      end

      def encode_control_names
        encode_int32(controls.size) +
          controls.each_with_index
            .map(&method(:encode_control_name))
            .flatten.join
      end

      def encode_control_name((name, control), index)
        [ encode_string(name), encode_int32(index) ]
      end

      def encode_nodes
        encode_int32(nodes.size) + nodes.map(&:encode).join
      end

      def encode_variants
        encode_int16(0)
      end
    end
  end
end
