#!/usr/bin/env ruby

require "json"


path = ARGV[0] or raise "Provide a path for the json dump of Ugens"
file = File.open File.expand_path(path)
data = JSON.load file


data.each do |name, specs|
  if specs["methods"].values.uniq.size != 1
    puts name
    puts specs["methods"]
  else
  end
end
