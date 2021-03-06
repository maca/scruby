module Scruby
  class Graph
    module Print
      class << self
        def print(root)
          puts visualize(root)
        end

        def visualize(root)
          visualize_node(root, [], "", nil)
        end

        protected

        def visualize_node(node, siblings, padding, param_name)
          is_last = node.eql? siblings.last

          # TODO: refactor
          inputs =
            if node.respond_to?(:inputs)
              node.inputs
            elsif node.respond_to?(:children)
              node.children
            else
              []
            end

          # TODO: refactor
          param_names = UgenGraph::UgenNode === node ? node.parameter_names : []

          child_padding =
            case
            when siblings.empty?
              padding
            when is_last
              padding + "    "
            else
              padding + " │  "
            end

          [
            padding,
            (" #{is_last ? '└' : '├'}─ " unless siblings.empty?),
            [ param_name, node.print_name ].compact.join(": "),
            ("\n" if inputs.any?),

            inputs.zip(param_names).map { |i, name|
              visualize_node(i, inputs, child_padding, name)
            },

            ("\n" unless is_last)
          ].join
        end
      end
    end
  end
end
