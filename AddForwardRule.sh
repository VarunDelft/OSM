curl_url="http://"$1"/cgi-bin/luci/rpc/auth "
curl_data="--data '{\"id\": 1,\"method\":\"login\",\"params\":[\"root\",\"\"]}'"
curl_cmd="curl -s "
curl_final=$curl_cmd$curl_url$curl_data
echo $curl_url$curl_data
sh "curl -s " $curl_url$curl_data
echo $Auth
Result=echo $Auth | jq .result
echo $Result
