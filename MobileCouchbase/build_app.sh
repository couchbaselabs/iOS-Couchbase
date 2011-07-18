#!/bin/sh
cd Vendor/CouchDB/src/$1
cat Makefile.am
erlc -W0 -o $3 $2
