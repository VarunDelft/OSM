#!/bin/sh
GetAuthcode(){
D=`cat Data/OSMAuthRequest.json`
#D=${D//__USER_NAME__/$2}
#D=${D//__PASSWORD__/$3}
D=`echo $D | sed -e "s/__USER_NAME__/${2}/g"`
D=`echo $D | sed -e "s/__PASSWORD__/${3}/g"`
RETURN_CODE=0
CURL_RETURN_CODE=0
CURL_OUTPUT=`echo $D | curl -k -d @- -m 100 -H "Accept:application/json" -H "Content-Type:application/json" -X POST https://$1/osm/admin/v1/tokens 2> /dev/null`  || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
	echo $D
    echo "error in getting outhorization code for ${CURL_OUTPUT}"
else
    RETURN_CODE=0
    Result=`echo ${CURL_OUTPUT} | jq .id`
    Result=`echo ${Result} | sed "s/\"//g"` 
   echo $Result
fi
return $RETURN_CODE
}


#Main Script Start Here
# $1 = IpAdress:port for the OSM Server
# $2 = User Name
# $3 = Password

Authcode="$(GetAuthcode $1 $2 $3)"
RETURN_CODE=`echo $?`
echo "${Authcode}"
exit $RETURN_CODE
