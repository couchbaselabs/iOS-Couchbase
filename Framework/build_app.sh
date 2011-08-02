#!/bin/sh
echo "Building $1 into $3"
cd ../../vendor/couchdb/src/$1
#cat Makefile.am
erlc -W0 +compressed -o $3 $2
