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

# Of course, the obvious and normal way to do this is to just define a local value.
function local_set_a_value(){
  local value="${1:-set}"
  echo "Value is: ${1:-set}"
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

## =(^ᴥ^)=$ local_set_a_value transient
## Value is: transient
##
## =(^ᴥ^)=$ echo $value
##
