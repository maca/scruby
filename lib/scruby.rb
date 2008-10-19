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
require 'yaml'

LIB_DIR = File.join( File.expand_path(File.dirname(__FILE__) ), 'scruby' )

$:.unshift( File.dirname(__FILE__) ) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'scruby/audio/ugen_operations' 
require 'scruby/audio/ugen' 
require 'scruby/audio/operation_ugens'
require 'scruby/control_name'
require 'scruby/synthdef'
require 'scruby/extensions'


