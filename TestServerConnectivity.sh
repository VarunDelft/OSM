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
    #echo ${CURL_OUTPUT}
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')
    if [ ${httpCode} -ne 200 ]; then
      #echo "Curl operation/command failed due to server return code - ${httpCode}"
      RETURN_CODE=1
      fi
fi
exit  ${RETURN_CODE}
