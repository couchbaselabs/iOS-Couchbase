{application, couch, [
    {description, "Apache CouchDB"},
    {vsn, "1.0.1-emonk-ios"},
    {modules, [couch,couch_app,couch_app_server,couch_app_server_emonk,couch_app_server_erlang,couch_app_server_os,couch_auth_cache,couch_btree,couch_changes,couch_config,couch_config_writer,couch_db,couch_db_update_notifier,couch_db_update_notifier_sup,couch_db_updater,couch_doc,couch_event_sup,couch_external_manager,couch_external_server,couch_file,couch_httpd,couch_httpd_auth,couch_httpd_db,couch_httpd_external,couch_httpd_misc_handlers,couch_httpd_oauth,couch_httpd_rewrite,couch_httpd_show,couch_httpd_stats_handlers,couch_httpd_vhost,couch_httpd_view,couch_key_tree,couch_log,couch_native_process,couch_os_process,couch_query_servers,couch_ref_counter,couch_rep,couch_rep_att,couch_rep_changes_feed,couch_rep_db_listener,couch_rep_httpc,couch_rep_missing_revs,couch_rep_reader,couch_rep_sup,couch_rep_writer,couch_server,couch_server_sup,couch_stats_aggregator,couch_stats_collector,couch_stream,couch_task_status,couch_util,couch_uuids,couch_view,couch_view_compactor,couch_view_group,couch_view_server,couch_view_server_emonk,couch_view_server_erlang,couch_view_server_os,couch_view_updater,couch_work_queue]},
    {registered, [
        couch_config,
        couch_db_update,
        couch_db_update_notifier_sup,
        couch_external_manager,
        couch_httpd,
        couch_log,
        couch_primary_services,
        couch_query_servers,
        couch_rep_sup,
        couch_secondary_services,
        couch_server,
        couch_server_sup,
        couch_stats_aggregator,
        couch_stats_collector,
        couch_task_status,
        couch_view
    ]},
    {mod, {couch_app, [
        "/usr/local/etc/couchdb/default.ini",
        "/usr/local/etc/couchdb/local.ini"
    ]}},
    {applications, [kernel, stdlib]},
    {included_applications, [crypto, sasl, inets, oauth, ibrowse, mochiweb]}
]}.
