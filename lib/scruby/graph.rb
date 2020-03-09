require "securerandom"

module Scruby
  class Graph
    include Encode

    attr_reader :name, :root, :nodes, :controls, :constants

    def initialize(root_ugen, name: nil, controls: {})
      @name = name || SecureRandom.uuid
      @controls = controls.map &method(:build_control_with_name)
      @nodes = []
      @constants = []
      @root = Node.build_root(self, root_ugen)

      add_node @root
    end

    def add_constant(const)
      const.tap do
        constants.push(const) unless constants.include?(const)
      end
    end

    def add_control(control_name)
      control_name.tap do
        next if nodes.any? { |c| c.ugen.is_a?(Control) }

        control = Control.new(rate: :control, control_names: controls)
        add_node Node.build(self, control)
      end
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

    def visualize
      Visualize.print(root)
    end

    def play(server, out: 0, fade_in: 0.2, position: :head, args: {})
    end

    private

    def add_node(node)
      return unless node.is_a?(Node)

      node.inputs.each &method(:add_node)
      nodes.push(node)
    end

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
