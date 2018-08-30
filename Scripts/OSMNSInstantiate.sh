#!/bin/sh
InstantiateNS(){
D="{ 
  \"nsdId\": \"$3\", 
  \"nsName\": \"$4\", 
  \"nsDescription\": \"$5\", 
  \"vimAccountId\": \"$6\" 
}"
RETURN_CODE=0
CURL_RETURN_CODE=0
#Abc='curl -k -d @- -m 100 -H "Accept:application/json" -H "Authorization: Bearer ${1}" -H "Content-Type:application/json" -X POST https://{$2}/osm/admin/v1/tokens'
Abc="curl -k -d @- -m 100 -H \"Accept:application/json\" -H \"Authorization: Bearer $1\" -H \"Content-Type:application/json\" -X POST https://$2/osm/nslcm/v1/ns_instances/$7/instantiate"
CURL_OUTPUT=`echo $D | curl -k -d @- -m 100 -H "Accept:application/json" -H "Authorization: Bearer $1" -H "Content-Type:application/json" -X POST https://$2/osm/nslcm/v1/ns_instances/$7/instantiate 2> /dev/null`  || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo $D
    echo "error in getting outhorization code for ${CURL_OUTPUT}"
else
    RETURN_CODE=0
    StatusCode=`echo ${CURL_OUTPUT} | jq .status`
    StatusCode=`echo ${StatusCode} | sed "s/\"//g"`
    if [ ${StatusCode} -ne 201 ]
    then
       RETURN_CODE=1
       echo $D
       echo "${CURL_OUTPUT}"
       echo "${Abc}"
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
# $7 = Instance id of the network service

NSInstanceID=$(InstantiateNS "${1}" "${2}" "$3" "$4" "$5" "$6" "$7")
RETURN_CODE=`echo $?`
echo ${NSInstanceID}
exit $RETURN_CODE
