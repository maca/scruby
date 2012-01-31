module Scruby
  class Group < Node
    def free_all
      send '/g_freeAll', self.id
      self
    end

    def deep_free
      send '/g_deepFree', self.id
      self
    end

    def dump_tree post = false
      send '/g_dumpTree', self.id, post
      self
    end
  end
end
