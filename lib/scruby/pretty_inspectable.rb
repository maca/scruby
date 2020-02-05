module Scruby
  module PrettyInspectable
    def inspect(**params)
      params = params.map { |k, v| "#{k}=#{v.inspect}" }.join(" ")
      "#<#{self.class.name || self.class} #{params}>"
    end
  end
end
