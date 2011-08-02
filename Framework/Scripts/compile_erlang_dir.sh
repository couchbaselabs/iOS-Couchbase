#!/bin/bash
#
# Subroutine of build_couchdb.sh that compiles a bunch of Erlang files into a destination dir.
# The current directory is assumed to be the parent of Couchbase.xcodeproj, and the couchdb repo
# is assumed to be checked out into a 'vendor' directory next to the iOS-Couchbase repo, as
# specified by the manifest.
#
# Usage:
#     build_app.sh sourcedirname filelist dstdir

set -e  # Bail out if any command returns an error

echo "Building $1 into $3"
cd "../../vendor/couchdb/src/$1"
erlc -W0 +compressed -o "$3" $2
