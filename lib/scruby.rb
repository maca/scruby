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

require 'rubygems'
require 'arguments'
require 'rosc'
require 'yaml'

require 'methopara' if RUBY_VERSION.to_f >= 1.9 


$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Scruby
  VERSION = '0.1'
end

SCRUBY_DIR = File.join( File.expand_path(File.dirname(__FILE__) ), 'scruby' )

require "scruby/typed_array"
require "scruby/extensions"

require "scruby/audio/ugens/ugen_operations"
require "scruby/audio/ugens/ugen"
require "scruby/audio/ugens/multi_out_ugens"
require "scruby/audio/ugens/in_out"

require "scruby/audio/ugens/operation_ugens"
require "scruby/audio/ugens/ugen"

require "scruby/audio/ugens/ugens"
require "scruby/audio/control_name"
require "scruby/audio/synthdef"

require "scruby/audio/server"
require "scruby/audio/env"
require "scruby/audio/ugens/env_gen"

require "scruby/audio/node"
require "scruby/audio/synth"

include Scruby
include Audio
include Ugens
include OperationUgens

class Notice < String; end
class Warning < String; end
class Special < String; end




