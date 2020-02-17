module Scruby
  class Graph
    include Encode

    attr_reader :name, :root, :nodes, :controls, :constants

    def initialize(root, name: nil, controls: {})
      @name = name
      @controls = controls.map &method(:build_control_with_name)
      @nodes = []
      @constants = []
      @root = Node.build_root(root, self)
    end

    def add_node(node)
      nodes.push(node)
    end

    def add_constant(const)
      return constants if constants.include?(const)
      constants.push(const)
    end

    def add_control(control)
      node = nodes.find { |c| c.ugen.is_a?(Control) }
      return node unless node.nil?

      control = Control.new(rate: :control, control_names: controls)
      Node.build(control, self)
    end

    def control_index(control)
      controls.index(control)
    end

    def control_name(name)
      controls.find { |control| control.name == name.to_sym } ||
        raise(KeyError, "control not found (#{name})")
    end

    def encode
      [
        init_stream(1),
        encode_string(name),
        encode_constants,
        encode_control_defaults,
        encode_control_names,
        encode_nodes,
        encode_variants
      ].join
    end

    private

    def init_stream(def_count = 1)
      version = 2
      [ "SCgf", encode_int32(version), encode_int16(def_count) ].join
    end

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
