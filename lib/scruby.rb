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


require "scruby/version"
require "scruby/attributes"
require "scruby/encode"
require "scruby/env"
require "scruby/control_name"


require "scruby/ugen"
require "scruby/ugen/base"
require "scruby/ugen/input"
require "scruby/ugen/graph"
require "scruby/ugen/graph/node"
require "scruby/ugen/ugen_operations"
require "scruby/ugen/multi_out"
require "scruby/ugen/panner"
require "scruby/ugen/buffer_read_write"
require "scruby/ugen/disk_in_out"
require "scruby/ugen/in_out"
require "scruby/ugen/operation_ugens"
require "scruby/ugen/demand"
require "scruby/ugen/env_gen"

require "scruby/synth_def"

require "scruby/server"
require "scruby/server/executable/options"
require "scruby/server/executable"

require "scruby/node"
require "scruby/synth"
require "scruby/bus"
require "scruby/buffer"
require "scruby/group"

require "scruby/ticker"




include Scruby
include Ugens
