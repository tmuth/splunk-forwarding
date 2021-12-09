export SPLUNK_HOME=/opt/splunk
export PATH=$PATH:$SPLUNK_HOME/bin

chmod -R g+rwx $SPLUNK_HOME/etc/apps/*

alias shome='cd $SPLUNK_HOME'
alias sapps='cd $SPLUNK_HOME/etc/apps'

SPLUNK_HOST=localhost:8089
AUTH_TOKEN= # Token authentication is the preferred method over username/password and is documented here:
# https://docs.splunk.com/Documentation/Splunk/latest/Security/EnableTokenAuth
SPLUNK_USERNAME=admin
SPLUNK_PASS=welcome1

#CLI_AUTH_OPTION=()
AUTH_OPTION=()
if [ ! -z "$AUTH_TOKEN" ]; then
    #CLI_AUTH_OPTION+=( -token ${AUTH_TOKEN} )
    AUTH_OPTION+=( -H "Authorization: Bearer ${AUTH_TOKEN}" )
    #echo "Using Token Auth"
else
    #CLI_AUTH_OPTION+=( -auth "${SPLUNK_USERNAME}:${SPLUNK_PASS}" )
    AUTH_OPTION+=( -u ${SPLUNK_USERNAME}:${SPLUNK_PASS} )
    #echo "Using User:Pass Auth"
fi

function config_reload {
  local CONFIG="${1}"
  curl_opts=( --silent --output /dev/null -k "${AUTH_OPTION[@]}" )
  curl_opts+=( --write-out "${CONFIG} reload, http-status: %{http_code}\n" )

  curl "${curl_opts[@]}"  -X POST https://${SPLUNK_HOST}/servicesNS/-/-/admin/${CONFIG}/_reload

}

function app_enable {
  local APP="${1}"
  local ACTION="${2}"
  curl_opts=( --silent --output /dev/null -k "${AUTH_OPTION[@]}" )
  curl_opts+=( --write-out "${APP} ${ACTION}, http-status: %{http_code}\n" )

  curl "${curl_opts[@]}"  -X POST https://${SPLUNK_HOST}/servicesNS/nobody/system/apps/local/${APP}/${ACTION}

}


function reload_configs {
    config_reload "alert_actions"
    config_reload "applicense"
    config_reload "auth-services"
    config_reload "bookmarks-mc"
    config_reload "clusterconfig"
    config_reload "collections-conf"
    config_reload "commandsconf"
    config_reload "conf-checklist"
    config_reload "conf-deploymentclient"
    config_reload "conf-inputs"
    config_reload "conf-times"
    config_reload "conf-wmi"
    config_reload "cooked"
    config_reload "crl"
    config_reload "datamodel-files"
    config_reload "datamodelacceleration"
    config_reload "datamodeledit"
    config_reload "dataset_consolidation_datamodeledit"
    config_reload "deploymentserver"
    config_reload "dfs-federated"
    config_reload "distsearch-peer"
    config_reload "eventtypes"
    config_reload "federated-index"
    config_reload "federated-provider"
    config_reload "fieldaliases"
    config_reload "fields"
    config_reload "fifo"
    config_reload "fshpasswords"
    config_reload "fvtags"
    config_reload "global-banner"
    config_reload "health-report-config"
    config_reload "http"
    config_reload "index-archiver"
    config_reload "indexer-discovery-config"
    config_reload "indexes"
    config_reload "journald"
    config_reload "limits"
    config_reload "livetail"
    config_reload "localapps"
    config_reload "lookup-table-files"
    config_reload "macros"
    config_reload "manager"
    config_reload "messages-conf"
    config_reload "metric-schema"
    config_reload "metric-schema-reload"
    config_reload "metric_alerts"
    config_reload "metrics-reload"
    config_reload "metricstore_rollup"
    config_reload "modalerts"
    config_reload "monitor"
    config_reload "nav"
    config_reload "panels"
    config_reload "passwords"
    config_reload "pools"
    config_reload "props-eval"
    config_reload "props-extract"
    config_reload "props-lookup"
    config_reload "proxysettings"
    config_reload "raw"
    config_reload "remote_eventlogs"
    config_reload "remote_indexes"
    config_reload "remote_monitor"
    config_reload "remote_perfmon"
    config_reload "remote_raw"
    config_reload "remote_script"
    config_reload "remote_udp"
    config_reload "savedsearch"
    config_reload "scheduledviews"
    config_reload "script"
    config_reload "search-head-bundles"
    config_reload "secure_gateway_modular_input"
    config_reload "serverclasses"
    config_reload "shclusterconfig"
    config_reload "sourcetype-rename"
    config_reload "sourcetypes"
    config_reload "splunktcptoken"
    config_reload "ssg_alerts_ttl_modular_input"
    config_reload "ssg_delete_tokens_modular_input"
    config_reload "ssg_device_role_modular_input"
    config_reload "ssg_enable_modular_input"
    config_reload "ssg_metrics_modular_input"
    config_reload "ssg_registered_users_list_modular_input"
    config_reload "ssg_subscription_clean_up_modular_input"
    config_reload "ssg_subscription_modular_input"
    config_reload "ssl"
    config_reload "syslog"
    config_reload "tags"
    config_reload "tcpout-default"
    config_reload "tcpout-group"
    config_reload "tcpout-server"
    config_reload "telemetry"
    config_reload "transforms-extract"
    config_reload "transforms-lookup"
    config_reload "transforms-reload"
    config_reload "transforms-statsd"
    config_reload "udp"
    config_reload "ui-prefs"
    config_reload "ui-tour"
    config_reload "views"
    config_reload "viewstates"
    config_reload "visualizations"
    config_reload "vix-indexes"
    config_reload "vix-providers"
    config_reload "workflow-actions"
    config_reload "workload-categories"
    config_reload "workload-config"
    config_reload "workload-policy"
    config_reload "workload-pools"
    config_reload "workload-rules"
    # Download all admin urls:
    # curl "${curl_opts[@]}"  -X GET https://${SPLUNK_HOST}/servicesNS/-/-/admin/ > urls.txt
    # Extract just the _reload components:
    # grep _reload urls.txt | sed -e 's/.*admin\/\/\(.*\)\/_reload.*/config_reload "\1"/'

    # debug search for list
    # index=_*  (NOT Workload AND NOT Workflow) sourcetype=splunkd_access "/servicesNS"
    # | dedup uri
    # | table uri
    # | sort uri

}

alias conf='reload_configs'
alias nc1='nc -k -l 6001'
alias nc2='nc -k -l 6002'
alias nct1='nc -k -l 6001 | tee -a ~splunk/nc1.txt'
alias nct2='nc -k -l 6002 | tee -a ~splunk/nc2.txt'
alias nct-clear='rm -f ~splunk/nc*.txt'




alias cp-config='cp /tmp/splunk/* /opt/splunk/etc/system/local'
#alias tail-metrics="tail -f $SPLUNK_HOME/var/log/splunk/metrics.log | grep --line-buffered --color=none \"group=queue.*largest_size=[1-9]\" | gawk 'BEGIN { FS = \",\" } ; {printf \" %-30s %-22s %-25s %-22s %-22s  \n\", \$2,\$3,\$4,\$5,\$6; fflush()}' | h current_size=[1-9]+\|current_size_kb=[1-9]+ "
alias tail-metrics='. /home/splunk/./tail-metrics.sh'
alias tail-autolb='tail -f $SPLUNK_HOME/var/log/splunk/splunkd.log | grep "TcpOutEloop"'
alias src='source /etc/profile.d/bashrc-custom.sh'
alias bashp='vi /etc/profile.d/bashrc-custom.sh'

alias enable-iaf='app_enable "split_forward" "disable"; app_enable "index_and_forward" "enable"; conf'
alias enable-sf='app_enable "index_and_forward" "disable"; app_enable "split_forward" "enable"; conf'

alias btool-i='splunk btool inputs list tcp --debug'
alias btool-p='splunk btool props list csv_test --debug'
alias btool-t='splunk btool transforms  list routeSubset --debug; \
  splunk btool transforms  list routeNull --debug; \
  splunk btool transforms  list setParse --debug; \
  splunk btool transforms  list cloneCsv --debug; '
alias btool-0='splunk btool outputs list'

