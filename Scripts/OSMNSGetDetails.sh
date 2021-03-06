#!/bin/sh
GetNSDetails(){
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
    #echo "${CURL_OUTPUT}"
    const_vnfds=`echo ${CURL_OUTPUT} | jq .\"nsd\".\"constituent-vnfd\"`
    #echo "$const_vnfds"
    fw_index=`echo ${const_vnfds} | jq '.[] | select(."vnfd-id-ref" | contains("fw")) | ."member-vnf-index"' | sed "s/\"//g"`
    server_index=`echo ${const_vnfds} | jq '.[] | select(."vnfd-id-ref" | contains("server")) | ."member-vnf-index"'  | sed "s/\"//g"`
    #echo "Firewall index is $fw_index"
    #echo "Server index is $server_index"
    const_vnfrs=`echo ${CURL_OUTPUT} | jq .\"constituent-vnfr-ref\"`
    #echo $const_vnfrs
    fw_id=`echo ${CURL_OUTPUT} | jq .\"constituent-vnfr-ref\"[$(($fw_index-1))]`
    server_id=`echo ${CURL_OUTPUT} | jq .\"constituent-vnfr-ref\"[$(($server_index-1))]`
    #echo "Firewall id is $fw_id"
    #echo "Server id is $server_id"
    vlds=`echo ${CURL_OUTPUT} | jq .\"nsd\".\"vld\"`
    #mgmt_index=`echo ${vlds} | jq 'map(select(."short-name" | contains("mgmt"))) | index(true)'`
    mgmt_index=`echo ${vlds} | jq 'map(."short-name" == "FwAndServerNs_mgmt_vld") | index(true)'` 
    prv_index=`echo ${vlds} | jq 'map(."short-name" == "FwAndServerNs_prv_vld_1") | index(true)'`
    #echo "Mgmt network array index is $mgmt_index"
    #echo "Prv network array index is $prv_index"
    NSDetails1="{\"FirewallId\":$fw_id,\"ServerId\":${server_id},\"FirewallMgmtIndex\":\"${mgmt_index}\",\"FirewallPrvIndex\":\"${prv_index}\",\"ServerMgmtIndex\":\"${mgmt_index}\",\"ServerPrvIndex\":\"${prv_index}\"}"
   #abc='"aa":"${fw_id}"'
   abc=""
    echo $NSDetails1
   # echo "${abc}"
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
