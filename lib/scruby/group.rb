module Scruby
  class Group < Node
    def free_all
      send "/g_freeAll", id
      self
    end

    def deep_free
      send "/g_deepFree", id
      self
    end

    def dump_tree(post = false)
      send "/g_dumpTree", id, post
      self
    end
  end
end
