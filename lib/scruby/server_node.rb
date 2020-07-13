module Scruby
  class ServerNode
    attr_reader :name, :server, :params, :type, :children_count
    attr_accessor :id, :group

    def initialize(server, children_count, name = nil, **params)
      @server = server
      @children_count = children_count
      @name = name
      @params = params
    end

    def group?
      children_count > -1
    end
  end
end
