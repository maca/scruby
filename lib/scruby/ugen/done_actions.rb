module Scruby
  module Ugen
    module DoneActions
      ACTIONS = %i(
        none
        pause
        free
        free_and_prev
        free_and_next
        free_and_all_in_prev
        free_and_all_in_next
        free_self_to_head
        free_self_to_tail
        free_and_pause_prev
        free_and_pause_next
        free_and_deep_prev
        free_and_deep_next
        free_and_siblings
        free_group
        free_and_resume_next
      )

      protected

      def done_action=(action)
        super ACTIONS.index(action) || action
      end
    end
  end
end
