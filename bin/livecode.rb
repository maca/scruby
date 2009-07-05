#!/usr/bin/env ruby
live_session_dir = File.join( File.expand_path(File.dirname(__FILE__) ), '..', 'lib', 'live' )

require 'tempfile'
require "#{live_session_dir}/session"


Live::Session.new




