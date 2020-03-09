require "singleton"

module Scruby
  class Server
    class Local < Server
      include Singleton
    end
  end
end
