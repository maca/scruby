module Scruby
  class Graph
    module Visualize
      class << self
        def print(root)
          puts print_node(root, [], "")
        end

        protected

        def print_node(node, siblings, padding)
          last = node == siblings.last
          inputs = node.inputs

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
            node.print_name,
            ("\n" if inputs.any?),
            inputs.map { |i| print_node(i, inputs, child_padding) },
            ("\n" unless last)
          ].join
        end
      end
    end
  end
end
