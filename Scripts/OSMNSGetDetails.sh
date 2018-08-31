#!/bin/sh
GetNSDetails(){

RETURN_CODE=0
CURL_RETURN_CODE=0
#Abc="curl -k -m 100 -H \"Accept:application/json\" -H \"Authorization: Bearer $1\" -H \"Content-Type:application/json\" -X GET https://$2/osm/nslcm/v1/ns_instances/$3"
CURL_OUTPUT=`curl -k  -m 100 -H "Accept:application/json" -H "Authorization: Bearer $1" -H "Content-Type:application/json" -X GET https://$2/osm/nslcm/v1/ns_instances/$3` 2> /dev/null  || CURL_RETURN_CODE=$?
#CURL_OUTPUT=`{$Abc} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo "error in getting outhorization code for ${CURL_OUTPUT}"
else
    #echo $Abc
    RETURN_CODE=0
    #echo "${CURL_OUTPUT}"
    Result=`echo ${CURL_OUTPUT} | jq .\"constituent-vnfr-ref\"`
    Result=`echo ${Result} | sed "s/\"//g"`
    echo "$Result"
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = Authorisation code
# $2 = OSM IP address:Port
# $3 = Instance id of the network service


NSDetails="$(GetNSDetails $1 $2 $3)"
RETURN_CODE=`echo $?`
NSDetails='{"FirewallId":"3e1379fd-f296-4ecc-930a-e4be07992ea3","ServerId":"fd949c1b-ce18-4abc-bb9c-7f4fc352ebdf","FirewallMgmtIndex":"0","FirewallPrvIndex":"1","ServerMgmtIndex":"0","ServerPrvIndex":"1"}'
echo "${NSDetails}"

exit $RETURN_CODE
