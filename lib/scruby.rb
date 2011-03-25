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

require 'date'
require 'rubygems'
require 'arguments'
require 'ruby-osc'
require 'eventmachine'
require 'yaml'

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "scruby/version"

require "scruby/core_ext/object"
require "scruby/core_ext/array"
require "scruby/core_ext/fixnum"
require "scruby/core_ext/numeric"
require "scruby/core_ext/proc"
require "scruby/core_ext/string"
require "scruby/core_ext/symbol"
require "scruby/core_ext/typed_array"
require "scruby/core_ext/delegator_array"
require "scruby/env"
require "scruby/control_name"

require "scruby/ugens/ugen"
require "scruby/ugens/ugen_operations"
require "scruby/ugens/multi_out"
require "scruby/ugens/panner"
require "scruby/ugens/buffer_read_write"
require "scruby/ugens/disk_in_out"
require "scruby/ugens/in_out"

require "scruby/ugens/operation_ugens"

require "scruby/ugens/ugens"
require "scruby/synthdef"

require "scruby/server"
require "scruby/ugens/env_gen"

require "scruby/node"
require "scruby/synth"
require "scruby/bus"
require "scruby/buffer"
require "scruby/group"

require "scruby/ticker"

include Scruby
include Ugens
