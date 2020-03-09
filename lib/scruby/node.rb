module Scruby
  module Node
    @@base_id = 999

    ACTIONS = %i(head tail before after replace).freeze

    def set(**args)
      server.send_msg "/n_set", id, *args.flatten
      self
    end

    def free
      server.send_msg "/n_free", id
      @group, @playing, @running = nil, false, false
      self
    end

    def playing?
      @playing
    end

    def run(run = true)
      server.send_msg "/n_run", id, run
      self
    end

    private

    def action_id
      ACTIONS.index(action)
    end

    def target_id
      # return target if target.is_a?(Server)
      # target.server
      0
    end

    def server
      return target if target.is_a?(Server)
      target.server
    end

    class << self
      def next_id
        @@base_id += 1
      end
    end
  end
end
