HTTPS_URL="http://"$1":8080"
CURL_CMD="curl -w httpcode=%{http_code}"
RETURN_CODE=0
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT="-m 100"
# perform curl operation
CURL_RETURN_CODE=0
CURL_OUTPUT=`${CURL_CMD} ${CURL_MAX_CONNECTION_TIMEOUT} ${HTTPS_URL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]
then
    RETURN_CODE=1
else
    #echo "Curl connection success"
    # Check http code for curl operation/response in  CURL_OUTPUT
    echo ${CURL_OUTPUT}
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')
    
	if [ $2 = "Open" ]
	then
		if [ ${httpCode} -ne 200 ]; then
		  echo "Test  failed. Not able to connect to server. return code - ${httpCode}"
		  RETURN_CODE=1
		else
		  echo "Test  Success. Connection to the server" ${1} "Successful at port 8080. Http code - "${httpCode}
		  RETURN_CODE=0
		fi
	fi
	
	if [ $2 = "Block" ]
	then
		if [ ${httpCode} -ne 200 ]; then
		  echo "Test Success Connection to the server" ${1} "Blocked at port 8080. Http code - "${httpCode}
		  RETURN_CODE=0
		else
		  echo "Test Faiiled. Connection to the server still exists Http code - "${httpCode}
		  RETURN_CODE=1
		fi
	fi

fi
exit  ${RETURN_CODE}
