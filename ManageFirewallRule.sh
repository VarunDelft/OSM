#!/bin/bash
GetAuthorisationCode(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/auth "
HTTPS_DATA="-d @ServerAuthData.json " 
RETURN_CODE=0
CURL_CMD_FINAL="${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}${HTTPS_DATA}" 
CURL_RETURN_CODE=0
CURL_OUTPUT=`${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in getting Authorization code"
    echo ${CURL_OUTPUT}
else
    Result=`echo ${CURL_OUTPUT} | jq .result`
    Result=`echo ${Result} | sed "s/\"//g"`
    RETURN_CODE=0
fi

}


AddFirewallRule(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/uci?auth="$Result" -d @- "
HTTPS_DATA=`cat AddRuleData.json`
HTTPS_DATA=${HTTPS_DATA//__DEST_IP_TO_CHANGE__/$2}
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

CommitFirewallRule(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/uci?auth="$Result" -d @- "
HTTPS_DATA=`cat CommitRuleData.json`
CURL_CMD_FINAL=${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}
CURL_RETURN_CODE=0
CURL_OUTPUT=`echo ${HTTPS_DATA} | ${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in comitting firewall rule"
    echo ${CURL_OUTPUT}
else
    RETURN_CODE=0
fi
}


ApplyFirewallRule(){
HTTPS_URL="http://"$1"/cgi-bin/luci/rpc/uci?auth="$Result" -d @- "
HTTPS_DATA=`cat ApplyRuleData.json`
CURL_CMD_FINAL=${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL}
CURL_RETURN_CODE=0
CURL_OUTPUT=`echo ${HTTPS_DATA} | ${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in Applying firewall rule"
    echo ${CURL_OUTPUT}
else
    RETURN_CODE=0
fi
}


#Main Script Start Here
Result=""
CURL_CMD="curl -H \"Accept: application/json\" -H \"Content-Type:application/json\" -X POST "
CURL_MAX_CONNECTION_TIMEOUT=" -m 100 "
CURL_RETURN_CODE=0
MAIN_RETURN_CODE=0

GetAuthorisationCode $1
if [ ${RETURN_CODE} -ne 0 ]
then
   exit ${RETURN_CODE}  
fi

AddFirewallRule $1 $2
if [ ${RETURN_CODE} -ne 0 ]
then
   exit ${RETURN_CODE}
fi

CommitFirewallRule $1
if [ ${RETURN_CODE} -ne 0 ]
then
   exit ${RETURN_CODE}
fi

ApplyFirewallRule $1
if [ ${RETURN_CODE} -ne 0 ]
then
   exit ${RETURN_CODE}
fi

exit 0
