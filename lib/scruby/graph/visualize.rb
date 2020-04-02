module Scruby
  class Graph
    module Visualize
      class << self
        def print(root)
          puts print_node(root, [], "", nil)
        end

        protected

        def print_node(node, siblings, padding, param_name)
          last = node == siblings.last
          inputs = node.respond_to?(:inputs) ? node.inputs : []
          param_names = UgenNode === node ? node.parameter_names : []

          child_padding =
            case
            when siblings.empty?
              padding
            when last
              padding + "    "
            else
              padding + " │  "
            end

          [
            padding,
            (" #{last ? '└' : '├'}─ " unless siblings.empty?),
            [ param_name, node.print_name ].compact.join(": "),
            ("\n" if inputs.any?),

            inputs.zip(param_names).map { |i, param_name|
              print_node(i, inputs, child_padding, param_name)
            },

            ("\n" unless last)
          ].join
        end
      end
    end
  end
end
