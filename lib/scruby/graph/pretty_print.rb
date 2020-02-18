module Scruby
  class Graph
    module PrettyPrint
      def print
        puts print_node(self, [], "")
      end

      protected

      def print_node(node, siblings, padding)
        last = node == siblings.last
        inputs = node.send(:inputs)

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
          node.send(:print_name),
          ("\n" if inputs.any?),
          inputs.map { |i| print_node(i, inputs, child_padding) },
          ("\n" unless last)
        ].join
      end
    end
  end
end
