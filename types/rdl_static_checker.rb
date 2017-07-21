#!/usr/bin/env ruby

if ARGV.length != 1 then
print "Usage: rdl_static_checker <file>"
  exit 0
end

require 'rdl'

require_relative ARGV[0]

RDL.do_typecheck
