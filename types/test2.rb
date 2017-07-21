#!/usr/bin/env ruby
require 'rdl'

extend RDL::Annotate

type '() -> Integer'
def f
  'haha'
end

RDL.do_typecheck :now

# def nil_echo
#   nil.echo
# end

# def string_int
#   "abc" + 1
# end
