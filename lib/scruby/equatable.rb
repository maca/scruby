module Scruby
  module Equatable
    def ==(other)
      self.class == other.class &&
        other.equatable_state == equatable_state
    end

    protected

    def equatable_state
      instance_variables.map { |name| instance_variable_get(name) }
    end
  end
end
