## Network Firewall Ingress

### Description
This is to integrate AWS network firewall to inspect all ingress connections by suricata

### POC

If you take a look on log insight using this query

**CloudWatch Logs Insights**  
region: ap-southeast-3  
log-group-names: /aws/network-firewall/alert  
start-time: -3600s  
end-time: 0s  
query-string:
```
filter (event.src_ip) = "180.252.123.23"
```
---
| @timestamp | @message |
| --- | --- |
| 2023-08-24 11:17:43.000 | {"firewall_name":"firewall","availability_zone":"ap-southeast-3a","event_timestamp":"1692875863","event":{"src_ip":"180.252.123.23","src_port":45045,"event_type":"alert","alert":{"severity":3,"signature_id":1,"rev":0,"signature":"","action":"allowed","category":""},"flow_id":1340995028876612,"dest_ip":"10.0.11.115","proto":"TCP","dest_port":22,"timestamp":"2023-08-24T11:17:43.163140+0000"}} |
| 2023-08-24 11:17:21.000 | {"firewall_name":"firewall","availability_zone":"ap-southeast-3a","event_timestamp":"1692875841","event":{"icmp_type":8,"src_ip":"180.252.123.23","src_port":0,"event_type":"alert","alert":{"severity":3,"signature_id":2,"rev":0,"signature":"aws:alert_established action","action":"blocked","category":""},"flow_id":253243020143388,"dest_ip":"10.0.11.115","proto":"ICMP","icmp_code":0,"dest_port":0,"timestamp":"2023-08-24T11:17:21.584476+0000"}} |
| 2023-08-24 10:48:18.000 | {"firewall_name":"firewall","availability_zone":"ap-southeast-3a","event_timestamp":"1692874098","event":{"src_ip":"180.252.123.23","src_port":44331,"event_type":"alert","alert":{"severity":3,"signature_id":1,"rev":0,"signature":"","action":"allowed","category":""},"flow_id":536380034962463,"dest_ip":"10.0.11.115","proto":"TCP","dest_port":22,"timestamp":"2023-08-24T10:48:18.381983+0000"}} |
| 2023-08-24 10:46:02.000 | {"firewall_name":"firewall","availability_zone":"ap-southeast-3a","event_timestamp":"1692873962","event":{"src_ip":"180.252.123.23","src_port":44293,"event_type":"alert","alert":{"severity":3,"signature_id":1,"rev":0,"signature":"","action":"allowed","category":""},"flow_id":135923717778563,"dest_ip":"10.0.11.115","proto":"TCP","dest_port":22,"timestamp":"2023-08-24T10:46:02.404611+0000"}} |
---

### Notes
Make sure you delete the firewall manually, terraform for AWS couldn't handle any error so instead of telling the error, it will indefinitely wait.