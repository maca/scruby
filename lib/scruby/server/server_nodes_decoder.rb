require "ostruct"

module Scruby
  class Server
    class ServerNodesDecoder
      include ServerNode::Proxy

      attr_reader :server

      def initialize(server)
        @server = server
      end

      def decode(msg)
        decode_node msg.to_enum.tap(&:next), nil, []
      end

      private

      def decode_node(bytes, group, acc)
        id = bytes.next
        children_count = bytes.next

        if children_count == -1
          return acc << associate(decode_synth(bytes), id, group)
        end

        node = ServerNode.new(server, children_count)
        ngroup = associate(node, id, group)

        acc << ngroup
        children_count.times.each { decode_node(bytes, ngroup, acc) }
        acc
      end


      def decode_synth(bytes)
        name = bytes.next
        params_count = bytes.next

        params =
          Hash[ *(params_count * 2).times.map { bytes.next } ]
            .transform_keys(&:to_sym)

        ServerNode.new(server, -1, name, **params)
      end

      def associate(node, id, group)
        node.id = id
        node.group = group
        node
      end
    end
  end
end
