#!/bin/sh
GetIPs(){

RETURN_CODE=0
CURL_RETURN_CODE=0
#Abc="curl -k  -m 100 -H \"Accept:application/json\" -H \"Authorization: Bearer $1\" -H \"Content-Type:application/json\" -X GET https://$2/osm/nslcm/v1/vnf_instances/$3"
CURL_OUTPUT=`curl -k  -m 100 -H "Accept:application/json" -H "Authorization: Bearer $1" -H "Content-Type:application/json" -X GET https://$2/osm/nslcm/v1/vnf_instances/$3` 2> /dev/null  || CURL_RETURN_CODE=$?
#CURL_OUTPUT=`{$Abc} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
    echo $Abc
    echo "${CURL_OUTPUT}"
    echo "error in getting outhorization code for ${CURL_OUTPUT}"
else
    #echo $Abc
    #RETURN_CODE=0
    #echo "${CURL_OUTPUT}"
    #echo $4
    #echo $5
    InternalIP=`echo ${CURL_OUTPUT} | jq -r .vdur[0].interfaces[$4].\"ip-address\"`
    ExternalIP=`echo ${CURL_OUTPUT} | jq -r .vdur[0].interfaces[$5].\"ip-address\"`
    echo "$InternalIP"
    echo "$ExternalIP"
    #echo "${CURL_OUTPUT}"
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = Authorisation code
# $2 = OSM IP address:Port
# $3 = NSInstanceDetails

D=`cat  Data/GetIPsData.json`
#D="{$3}"
FirewallId=`echo ${D} | jq -r .FirewallId`
ServerId=`echo ${D} | jq -r .ServerId`
FirewallMgmtIndex=$(expr `echo ${D} | jq -r .FirewallMgmtIndex` + 0 )
#echo $FirewallMgmtIndex 
FirewallPrvIndex=$(expr `echo ${D} | jq -r .FirewallPrvIndex` + 0 )
#echo $FirewallPrvIndex 
ServerMgmtIndex=$(expr `echo ${D} | jq -r .ServerMgmtIndex` + 0 )
ServerPrvIndex=$(expr `echo ${D} | jq -r .ServerPrvIndex` + 0 )
FirewallIPDetails="$(GetIPs $1 $2 $FirewallId $FirewallMgmtIndex $FirewallPrvIndex)"
RETURN_CODE=`echo $?`
echo "${FirewallIPDetails}"
ServerIPDetails="$(GetIPs $1 $2 $ServerId $ServerMgmtIndex $ServerPrvIndex)"
RETURN_CODE=`echo $?`
echo "${ServerIPDetails}"
exit $RETURN_CODE

