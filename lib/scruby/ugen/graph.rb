module Scruby
  module Ugen
    class Graph
      include Encode

      attr_reader :name, :root, :nodes, :controls, :constants

      def initialize(root, name: nil, controls: {})
        @name = name
        @controls = controls.map &method(:build_control_with_name)
        @nodes = []
        @constants = []
        @root = Node.new(root, self)
      end

      def add_node(node)
        @nodes.push(node)
      end

      def add_constant(const)
        @constants.push(const)
      end

      def add_control(control)
        node = nodes.find { |c| c.value.is_a?(Control) }
        return node unless node.nil?

        control = Control.new(rate: :control, control_names: controls)
        Node.new(control, self)
      end

      def build_control_node(control_name)
        node = nodes.find { |c| c.value.is_a?(Control) }
        return node unless node.nil?

        control = Control.new(rate: :control, control_names: controls)
        Node.new(control, self)
      end

      def control_index(control)
        controls.index(control)
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

      def get_control_name(name)
        controls.find { |control| control.name == name.to_sym } ||
          raise(KeyError, "control not found (#{name})")
      end

      private

      def build_control_with_name(name, default)
        build_control(default).tap { |control| control.name = name }
      end

      def build_control(default)
        return default if default.is_a?(ControlName)
        ControlName.new(default)
      end

      def encode_constants
        encode_floats_array constants.map(&:value)
      end

      def encode_control_defaults
        encode_floats_array controls.map(&:default)
      end

      def encode_control_names
        encode_int32(controls.size) +
          controls.map { |control| control.encode_name(self) }.join
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
