#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "erb"
require "facets/string/camelcase"
require "facets/string/snakecase"


path = ARGV[0] or raise "Provide a path for the json dump of Ugens"
file = File.open File.expand_path(path)
data = JSON.load file


data.each do |name, specs|
  rate_map = { ar: :audio, kr: :control, ir: :scalar }
  rates = specs["methods"].map { |k, _| rate_map[k.to_sym] }
  inputs = specs["methods"].to_a.first.last


  input_spec = inputs.map do |input, value|
    values =
      specs["methods"].map { |_, values| values.assoc(input).last }

    defaults =
      if values.uniq.size == 1
        value.inspect
      else
        "{ %s }" % rates.zip(values)
                     .map { |r, v| "#{r}: #{v.inspect}" }.join(", ")
      end

    input =
      case input
      when "in" then "input"
      when "end" then "finish"
      when "rate" then "playback_rate"
      else
        input
      end

    "#{input.snakecase}: #{defaults}".gsub(/\.0$/, "")
  end

  template =
<<~RUBY
module Scruby
  module Ugen
    class <%= name.sub("_", "") %> < Base
      <% if specs['isOut'] == true  %>
      include AbstractOut
      <% end -%>

      rates <%= rates.map(&:inspect).join(', ') -%>
      <% unless inputs.empty? %>
      inputs <%= input_spec.join(', ')
                  .scan(/(.{1,60})(?:,|$)/m).join(",\n#{ ' ' * 14 }") %>
      <% end -%>

    end
  end
end
RUBY

  file_name = "./lib/scruby/ugen/#{name.snakecase}.rb"
  File.write file_name, ERB.new(template, nil, "-").result(binding)
end
