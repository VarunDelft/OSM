## LOGIN

curl http://192.168.60.149/cgi-bin/luci/rpc/auth --data '{"id": 1,"method":"login","params":["root",""]}'

OUTPUT: {"id":1,"result":"75e3822e540d8f34a8694f3545ce6f2b","error":null}


## ADD NEW SECTION TO ALLOW HTTP

curl -X POST http://192.168.60.149/cgi-bin/luci/rpc/uci?auth=54d6547cbbd303e5412197604ca7a94c --data '
{
  "id": "1",
  "method": "section",
  "params": ["firewall", "redirect", "allowhttp", {"src" : "lan", "src_dport" : "8080", "dest" : "wan", "dest_ip" : "172.16.1.15", "dest_port" : "80", "proto" : "tcp", "target" : "DNAT"}]
}'



curl -X POST http://192.168.60.149/cgi-bin/luci/rpc/uci?auth=54d6547cbbd303e5412197604ca7a94c --data '
{
  "id": "1",
  "method": "commit",
  "params": ["firewall"]
}'

curl -X POST http://192.168.60.149/cgi-bin/luci/rpc/uci?auth=54d6547cbbd303e5412197604ca7a94c  --data '
{
  "id": "1",
  "method": "apply",
  "params": ["firewall"]
}'

