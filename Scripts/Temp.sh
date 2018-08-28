#!/bin/bash


AddFirewallRule(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/uci?auth= -d @- "
HTTPS_DATA=`cat Data/OSMAuthRequest.json`
HTTPS_DATA=${HTTPS_DATA//__USER_NAME__/$2}
HTTPS_DATA=${HTTPS_DATA//__PASSWORD__/$3}
CURL_CMD_FINAL=${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}
CURL_RETURN_CODE=0
CURL_OUTPUT=`echo ${HTTPS_DATA} | ${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?

if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in Adding firewall rule"
    echo ${CURL_OUTPUT}
else
    RETURN_CODE=0
fi
}


#Main Script Start Here
Result=""
CURL_CMD="curl -k -H \"Accept: application/json\" -H \"Content-Type:application/json\" -X POST "
CURL_MAX_CONNECTION_TIMEOUT=" -m 100 "
CURL_RETURN_CODE=0
MAIN_RETURN_CODE=0
AddFirewallRule $1 $2 $3