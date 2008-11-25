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
require 'ruby2ruby'
require "named_arguments"
require 'osc'
require 'yaml'

SCRUBY_DIR = File.join( File.expand_path(File.dirname(__FILE__) ), 'scruby' )


require "#{SCRUBY_DIR}/audio/ugens/ugen_operations"
require "#{SCRUBY_DIR}/audio/ugens/ugen"
require "#{SCRUBY_DIR}/audio/ugens/multi_out_ugens"
require "#{SCRUBY_DIR}/audio/ugens/in_out"

require "#{SCRUBY_DIR}/audio/ugens/operation_ugens"
require "#{SCRUBY_DIR}/audio/ugens/ugen"

require "#{SCRUBY_DIR}/audio/ugens/ugens"
require "#{SCRUBY_DIR}/audio/control_name"
require "#{SCRUBY_DIR}/audio/synthdef"
require "#{SCRUBY_DIR}/extensions"

require "#{SCRUBY_DIR}/audio/server"

require "#{SCRUBY_DIR}/audio/env"
require "#{SCRUBY_DIR}/audio/ugens/env_gen"


include Scruby
include Audio
include Ugens
include OperationUgens


class Notice < String; end
class Warning < String; end
class Special < String; end


