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
    echo "${CURL_OUTPUT}"
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = Authorisation code
# $2 = OSM IP address:Port
# $3 = Instance id of the network service

for i in `seq 1 12`
do
	NSDetails="$(GetStatus $1 $2 $3)"
	echo "iteration $i"
	echo "======================================================================================================================"
	echo "${NSDetails}"
	sleep 5s
done


for i in `seq 1 10`
do
	NSDetails="$(GetStatus $1 $2 $3)"
	echo "iteration $i"
	echo "======================================================================================================================"
	echo "${NSDetails}" 
	sleep 1m
done

exit 0
