# frozen_string_literal: true

#--
# Copyright (c) 2008 Macario Ortega
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

require "date"
require "ruby-osc"
require "eventmachine"
require "yaml"

require "scruby/core_ext/delegator_array"


module Scruby
  module Encode
    def encode_floats_array(array)
      [ array.size ].pack("n") + array.pack("g*")
    end

    def encode_string(string)
      [ string.size & 255 ].pack("C*") + string[0..255]
    end
  end
end


require "extensions/attributes"

require "scruby/version"
require "scruby/env"
require "scruby/control_name"

require "scruby/ugen"
require "scruby/ugen/input"
require "scruby/ugens/ugen_operations"
require "scruby/ugens/multi_out"
require "scruby/ugens/panner"
require "scruby/ugens/buffer_read_write"
require "scruby/ugens/disk_in_out"
require "scruby/ugens/in_out"
require "scruby/ugens/operation_ugens"
require "scruby/ugens/demand"

require "scruby/synthdef"

require "scruby/server"
require "scruby/server/options"
require "scruby/server/executable"

require "scruby/ugens/env_gen"

require "scruby/node"
require "scruby/synth"
require "scruby/bus"
require "scruby/buffer"
require "scruby/group"

require "scruby/ticker"




include Scruby
include Ugens
