#!/bin/bash
GetAuthorisationCode(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/auth "
#HTTPS_DATA="{\"id\": 1,\"method\":\"login\",\"params\":[\"root\",\"\"]}"
HTTPS_DATA="-d @ServerAuthData.json " 
CURL_CMD="curl -H \"Accept: application/json\" -H \"Content-Type:application/json\" -X POST "
RETURN_CODE=0
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT=" -m 100 "
# perform curl operation
CURL_RETURN_CODE=0
CURL_CMD_FINAL="${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}${HTTPS_DATA}" 

CURL_OUTPUT=`${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
#    echo "${CURL_RETURN_CODE}"
#    echo "${CURL_OUTPUT}"
else
    #echo "Curl connection success"
    # Check http code for curl operation/response in  CURL_OUTPUT
    Result=`echo ${CURL_OUTPUT} | jq .result`
    Result=`echo ${Result} | sed "s/\"//g"`
    #echo "${Result}"
fi
}


AddFirewallRule(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/uci?auth="$Result" -d @- "
HTTPS_DATA=`cat AddRuleData.json`
HTTPS_DATA=${HTTPS_DATA//__DEST_IP_TO_CHANGE__/172.16.1.15}
CURL_CMD_FINAL=${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}"'"${HTTPS_DATA}"'"
CURL_OUTPUT=`echo ${HTTPS_DATA} | ${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
}

CommitFirewallRule(){
}

#Main Script Start Here
Result=""
GetAuthorisationCode $1
AddFirewallRule $1
exit 0
