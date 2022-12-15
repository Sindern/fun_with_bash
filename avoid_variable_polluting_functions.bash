#! /bin/bash

# To avoid having to clutter up functions with an "unset" for each variable set by the function,
#  it may be better to just avoid having them set persistently to begin with.

# The function that actually does stuff:
function __set_a_value(){
  value="${1:-set}"
  echo "Value is: ${1:-set}"
}

# Wrapper function that executes above function in a (subshell) so variables aren't persistent.
function set_a_value(){
  (__set_a_value $*)
}

# Test:

## $ __set_a_value persistent
##   Value is: persistent
##
## $ echo $value
##   persistent

## $ set_a_value transient
##   Value is: transient
##
## $ echo $value
##
