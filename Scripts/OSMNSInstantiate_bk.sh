#!/bin/bash
GetAuthorisationCode(){
#CURL_CMD="curl -k -H 'Accept: application/json' -H 'Content-Type:application/json' -X POST "
CURL_CMD="curl -k -H 'Accept: application/json' -H 'Content-Type:application/json' -X POST "
CURL_MAX_CONNECTION_TIMEOUT=" -m 100 "
HTTPS_URL="https://"$1"/osm/admin/v1/tokens -d @- "
HTTPS_DATA=`cat Data/OSMAuthRequest.json`
HTTPS_DATA=${HTTPS_DATA//__USER_NAME__/$2}
HTTPS_DATA=${HTTPS_DATA//__PASSWORD__/$3}
RETURN_CODE=0
CURL_CMD_FINAL=${CURL_CMD}${CURL_MAX_CONNECTION_TIMEOUT}${HTTPS_URL} 
CURL_RETURN_CODE=0
echo ${CURL_CMD_FINAL}
echo ${HTTPS_DATA}
CURL_OUTPUT=`echo ${HTTPS_DATA} | ${CURL_CMD_FINAL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in getting Authorization code"
    echo ${CURL_OUTPUT}
else
    echo ${CURL_OUTPUT}
    Result=`echo ${CURL_OUTPUT} | jq .id`
    Result=`echo ${Result} | sed "s/\"//g"`
    RETURN_CODE=0
fi
echo $Result
}


# Main code starts here
AuthCode="$(GetAuthorisationCode $1 $2 $3)"
#GetAuthorisationCode $1 $2 $3
echo "${AuthCode}"

