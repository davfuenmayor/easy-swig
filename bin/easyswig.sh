#!/bin/bash

initialdir=$(pwd)
basedir=$(dirname $0)
#cd $basedir/../lib
ruby $basedir/../lib/easy-swig-cli.rb $@
#cd $initialdir

