require "ostruct"

module Scruby
  class Graph
    module Decoder
      class << self
        def decode(msg)
          Graph.new decode_node(msg.to_enum.tap(&:next), nil, [])
        end

        private

        def decode_node(bytes, parent, acc)
          id = bytes.next
          children_count = bytes.next

          if children_count == -1
            return acc << associate(decode_synth(bytes), id, parent)
          end

          nparent = associate(Graph::Node.new, id, parent)

          acc << nparent
          children_count.times.each { decode_node(bytes, nparent, acc) }
          acc
        end


        def decode_synth(bytes)
          name = bytes.next
          params_count = bytes.next

          params =
            Hash[ *(params_count * 2).times.map { bytes.next } ]
              .transform_keys(&:to_sym)

          Graph::Node.new(name, **params)
        end

        def associate(node, id, parent)
          node.id = id
          node.parent = parent
          node
        end
      end
    end
  end
end
