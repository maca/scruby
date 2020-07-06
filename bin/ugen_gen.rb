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


  inputs = specs["methods"].to_a.first.last.to_h
  attrs = {}


  if specs['isMultiOut']
    names = %w(numChannels numChans)

    attrs = inputs.slice(*names).transform_values { 1 }
    inputs = inputs.reject { |k, _| names.include?(k) }
  end


  map_names = proc do |input, value|
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
      when "numChannels" then "channel_count"
      when "numChans" then "channel_count"
      when "rate" then "playback_rate"
      else
        input
      end

    "#{input.snakecase}: #{defaults}".gsub(/\.0$/, "")
  end


  inputs = inputs.map(&map_names)
  attrs = attrs.map(&map_names)


  template =
<<~RUBY
module Scruby
  module Ugen
    class <%= name.sub("_", "") -%>
      <% if specs['isOut'] == true  %>
      < AbstractOut
      <% else %>
      < Gen
      <% end -%>

      rates <%= rates.map(&:inspect).join(', ') -%>
      <% unless attrs.empty? %>
      attributes <%= attrs.join(', ')
                  .scan(/(.{1,60})(?:,|$)/m).join(",\n#{ ' ' * 16 }") %>
      <% end -%>
      <% unless inputs.empty? %>
      inputs <%= inputs.join(', ')
                  .scan(/(.{1,60})(?:,|$)/m).join(",\n#{ ' ' * 12 }") %>
      <% end -%>

    end
  end
end
RUBY

  file_name = "./lib/scruby/ugen/#{name.snakecase}.rb"
  File.write file_name, ERB.new(template, nil, "-").result(binding)
end
