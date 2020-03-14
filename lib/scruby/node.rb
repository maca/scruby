module Scruby
  module Node
    ACTIONS = %i(head tail before after replace).freeze

    @@base_id = 999
    attr_reader :server, :id, :group


    def initialize(server)
      @server = server
      @id = Node.next_id
    end

    def free(send_flag = true)
      # @group = nil
      # @is_running = false
      send_msg('/n_free', id)
    end

    def run
      send_msg('/n_run', id, true)
    end

    def set(**args)
      send_msg('/n_set', id, *args.flatten)
    end

    def map(**args)
      messages =
        args.group_by { |_, b| b.rate }.map(&method(:message_for_map))

      send_bundle(*messages.compact)
    end

    # def playing?
    #   @playing
    # end

    # def run(run = true)
    #   server.send_msg "/n_run", id, run
    #   self
    # end

    private

    def send_msg(*args)
      server.send_msg(*args)
      self
    end

    def send_bundle(*args)
      server.send_bundle(*args)
      self
    end

    def action_id
      ACTIONS.index(action)
    end

    def target_id
      # return target if target.is_a?(Server)
      # target.server
      0
    end

    def message_for_map(rate, params)
      args = params.map { |n, bus| [ n, bus.index, bus.channels ] }

      case rate
      when :control
        [ '/n_mapn', id, *args ].flatten
      when :audio
        [ '/n_mapan', id, *args ].flatten
      end
    end

    class << self
      def next_id
        @@base_id += 1
      end
    end
  end
end
