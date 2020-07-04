require 'ostruct'

module Scruby
  class Server
    module NodeTreeDecoder
      class << self
        def decode(server, msg)
          bytes = msg.to_enum
          _ = bytes.next

          decode_node(bytes, server, nil)
        end

        def decode_node(bytes, server, parent)
          id = bytes.next
          children_count = bytes.next

          return decode_synth(bytes, server, id) if children_count == -1

          Group.new(server, id).tap do |group|
            group.children =
              children_count
                .times
                .map { decode_node(bytes, server, group) }
          end
        end

        def decode_synth(bytes, server, id)
          name = bytes.next
          params_count = bytes.next
          params = Hash[*(params_count * 2).times.map { bytes.next }]

          Synth.new(name, server, id, params)
        end
      end
    end
  end
end
