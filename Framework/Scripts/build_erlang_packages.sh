#!/bin/bash
#
# This script is called by a build phase in the Couchbase.framework target of the Couchbase project.
# It compiles the Erlang source code of Couchbase and its dependencies.
# The current directory is assumed to be the parent of Couchbase.xcodeproj.

set -e  # Bail out if any command returns an error
export PATH=$PATH:/usr/local/bin:/opt/local/bin  # Erlang is often installed in nonstandard places

ERLANG_DSTDIR="${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/CouchbaseResources/erlang"
COMPILE=Scripts/compile_erlang_dir.sh

# First copy the checked-in erlang resources into the framework:
echo "Copying erlang dir to ${ERLANG_DSTDIR}"
ditto "${SRCROOT}/erlang" "${ERLANG_DSTDIR}"

# Now compile the Erlang libraries we build from source:
$COMPILE couchdb "couch.erl couch_api_wrap.erl couch_api_wrap_httpc.erl couch_app.erl couch_app_server.erl couch_app_server_emonk.erl couch_app_server_erlang.erl couch_auth_cache.erl couch_btree.erl couch_changes.erl couch_compaction_daemon.erl couch_compress.erl couch_compress_types.erl couch_config.erl couch_config_writer.erl couch_db.erl couch_db_frontend.erl couch_db_update_notifier.erl couch_db_update_notifier_sup.erl couch_db_updater.erl couch_doc.erl couch_drv.erl couch_event_sup.erl couch_external_manager.erl couch_external_server.erl couch_file.erl couch_httpc_pool.erl couch_httpd.erl couch_httpd_auth.erl couch_httpd_db.erl couch_httpd_external.erl couch_httpd_misc_handlers.erl couch_httpd_oauth.erl couch_httpd_proxy.erl couch_httpd_replicator.erl couch_httpd_rewrite.erl couch_httpd_show.erl couch_httpd_stats_handlers.erl couch_httpd_vhost.erl couch_httpd_view.erl couch_httpd_view_merger.erl couch_internal_load_gen.erl couch_key_tree.erl couch_log.erl couch_native_process.erl couch_os_daemons.erl couch_os_process.erl couch_primary_sup.erl couch_query_servers.erl couch_ref_counter.erl couch_rep_sup.erl couch_replication_manager.erl couch_replication_notifier.erl couch_replicator.erl couch_replicator_doc_copier.erl couch_replicator_rev_finder.erl couch_replicator_utils.erl couch_secondary_sup.erl couch_server.erl couch_server_sup.erl couch_stats_aggregator.erl couch_stats_collector.erl couch_stream.erl couch_task_status.erl couch_util.erl couch_uuids.erl couch_view.erl couch_view_compactor.erl couch_view_group.erl couch_view_merger.erl couch_view_server.erl couch_view_server_emonk.erl couch_view_server_erlang.erl couch_view_server_os.erl couch_view_updater.erl couch_work_queue.erl json_stream_parse.erl couch_ios.erl" "$ERLANG_DSTDIR/lib/couch/ebin"
$COMPILE erlang-oauth "oauth.erl oauth_hmac_sha1.erl oauth_http.erl oauth_plaintext.erl oauth_rsa_sha1.erl oauth_unix.erl oauth_uri.erl" "$ERLANG_DSTDIR/lib/erlang-oauth/ebin"
$COMPILE ibrowse "ibrowse.erl ibrowse_app.erl ibrowse_http_client.erl ibrowse_lb.erl ibrowse_lib.erl ibrowse_sup.erl ibrowse_test.erl" "$ERLANG_DSTDIR/lib/ibrowse"
$COMPILE mochiweb "mochifmt.erl mochifmt_records.erl mochifmt_std.erl mochiglobal.erl mochihex.erl mochijson.erl mochijson2.erl mochilists.erl mochilogfile2.erl mochinum.erl mochitemp.erl mochiutf8.erl mochiweb.erl mochiweb_acceptor.erl mochiweb_app.erl mochiweb_charref.erl mochiweb_cookies.erl mochiweb_cover.erl mochiweb_echo.erl mochiweb_headers.erl mochiweb_html.erl mochiweb_http.erl mochiweb_io.erl mochiweb_mime.erl mochiweb_multipart.erl mochiweb_request.erl mochiweb_request_tests.erl mochiweb_response.erl mochiweb_skel.erl mochiweb_socket.erl mochiweb_socket_server.erl mochiweb_sup.erl mochiweb_util.erl reloader.erl" "$ERLANG_DSTDIR/lib/mochiweb/ebin"
$COMPILE ejson "ejson.erl mochijson2.erl mochinum.erl" "$ERLANG_DSTDIR/lib/ejson/ebin"
$COMPILE snappy "snappy.erl" "$ERLANG_DSTDIR/lib/snappy/ebin"
$COMPILE emonk/src "emonk.erl" "$ERLANG_DSTDIR/lib/emonk/ebin"

# Strip debug info & symbols out of the .beam files -- this saves a LOT of disk space:
echo "Stripping .beam files..."
cd "${ERLANG_DSTDIR}"
erl -noinput -eval 'erlang:display(beam_lib:strip_release("."))' -s init stop
