# TestOSM capabilities with virtual firewall

This project demonstrates capabilities for virtual firewall on OSM
with OpenWRT
To test place a file call FirewallConfig in the root folder
with either on of the structures below

{
"mode":"Open",
"FirewallIP":"192.168.60.149",
"ServerIP":"172.16.1.15"
}


{
"mode":"Block",
"FirewallIP":"192.168.60.149",
"ServerIP":"172.16.1.15"
}


