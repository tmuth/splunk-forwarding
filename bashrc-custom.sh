export SPLUNK_HOME=/opt/splunk
export PATH=$PATH:$SPLUNK_HOME/bin

alias shome='cd $SPLUNK_HOME'

SPLUNK_HOST=localhost:8089
AUTH_TOKEN=# Token authentication is the preferred method over username/password and is documented here:
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

function reload_configs {
    config_reload "conf-inputs"
    config_reload "conf-fields"
    config_reload "conf-transforms"
    config_reload "transforms-reload"
    config_reload "conf-props"
    config_reload "tcpout-default"
    config_reload "tcpout-group"
    config_reload "tcpout-server"
}

alias conf='reload_configs'