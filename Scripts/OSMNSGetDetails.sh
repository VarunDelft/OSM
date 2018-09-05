#!/bin/sh
GetStatus(){
RETURN_CODE=0
CURL_RETURN_CODE=0
        Abc="curl -k  -m 100 -H \"Accept:application/json\" -H \"Authorization: Bearer $1\" -H \"Content-Type:application/json\" -X GET https://$2/osm/nslcm/v1/ns_instances/$3"
#echo "Heere"
CURL_OUTPUT=`curl -k  -m 100 -H  "Accept:application/json"  -H  "Authorization: Bearer $1"  -H  "Content-Type:application/json"  -X GET https://$2/osm/nslcm/v1/ns_instances/$3` 2> /dev/null  || CURL_RETURN_CODE=$?
#echo "Here2"
#echo $Abc
#CURL_OUTPUT=`{$Abc} 2> /dev/null` || CURL_RETURN_CODE=$?
CURL_OUTPUT=`echo $CURL_OUTPUT | gawk -v RS='"' 'NR % 2 == 0 { gsub(/\n/, "") } { printf("%s%s", $0, RT) }'`
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo $Abc
    echo "error in getting Instance Details for  ${CURL_OUTPUT}"
    echo "${CURL_OUTPUT}"
else
    #echo $Abc
    RETURN_CODE=0
    echo "Ready"
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = Authorisation code
# $2 = OSM IP address:Port
# $3 = Instance id of the network service
NSDetails="$(GetNSDetails $1 $2 $3)"
RETURN_CODE=`echo $?`
echo "${NSDetails}"
exit $RETURN_CODE
