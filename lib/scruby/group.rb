module Scruby
  class Group < Node
    
    def free_all
      send '/g_freeAll', self.node_id
      self
    end
    
    def deep_free
      send '/g_deepFree', self.node_id
      self
    end
    
    def dump_tree post = false
      send '/g_dumpTree', self.node_id, post
      self
    end
    
    class << self
      
    end
    
  end
end