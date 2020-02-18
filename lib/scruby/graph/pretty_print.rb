module Scruby
  class Graph
    module PrettyPrint
      def print_node(level = 0)
        puts do_print_node(level)
      end

      protected

      def do_print_node(level)
        level = level + 1

        # space_one = " " * level
        # space = "  " * (level + 1)

        [
          print_name,
          ("\n├" if inputs.any?),
          inputs.map { |i| i.do_print_node(level) }.join
        ].join


        # [
        #   print_name,
        #   "\n",
        #   space,
        #   # "\n│\n",
        #   # "├",
        #   # "─" * (level + 1),
        #   inputs.map { |input| input.do_print_node(level + 1) }
        # ].join

        # [ print_name,
        #   inputs.map { |input| "   #{input.print_node}" },
        # ].join("\n")
      end
    end
  end
end
