#!/bin/sh
CreateNS(){
D="{ 
  \"nsdId\": \"$3\", 
  \"nsName\": \"$4\", 
  \"nsDescription\": \"$5\", 
  \"vimAccountId\": \"$6\" 
}"
RETURN_CODE=0
CURL_RETURN_CODE=0
Abc='curl -k -d @- -m 100 -H "Accept:application/json" -H "Authorization: Bearer $1" -H "Content-Type:application/json" -X POST https://$2/osm/admin/v1/tokens'
CURL_OUTPUT=`echo $D | curl -k -d @- -m 100 -H "Accept:application/json" -H "Authorization: Bearer $1" -H "Content-Type:application/json" -X POST https://$2/osm/admin/v1/tokens 2> /dev/null`  || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
	echo $D
    echo "error in getting outhorization code for ${CURL_OUTPUT}"
else
    RETURN_CODE=0
    StatusCode=`echo ${CURL_OUTPUT} | jq .Status`
    StatusCode=`echo ${StatusCode} | sed "s/\"//g"`
    if [ ${StatusCode} -ne 201]
    then
       RETURN_CODE=1
       echo "${CURL_OUTPUT}"
       echo "Error in Creating Network Service"
    else
       Result=`echo ${CURL_OUTPUT} | jq .id`
       Result=`echo ${Result} | sed "s/\"//g"`
       echo $Result
    fi
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = Authorisation code
# $2 = OSM IP address:Port
# $3 = NSDID
# $4 = nsName
# $5 = nsDescription
# $6 = vimAccountId

NSID=$(CreateNS "${1}" "${2}" "$3" "$4" "$5" "$6")
RETURN_CODE=`echo $?`
echo ${NSID}
exit $RETURN_CODE
