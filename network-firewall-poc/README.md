## Network Firewall Ingress

If you take a look on log insight using this query

```
filter (event.src_ip) = "<IP>"
```

You should be able to see this

```
@timestamp,@message
2023-08-24 10:50:10.000,"{""firewall_name"":""firewall"",""availability_zone"":""ap-southeast-3a"",""event_timestamp"":""1692874210"",""event"":{""src_ip"":""180.252.123.23"",""src_port"":44293,""tcp"":{""tcp_flags"":""1e"",""syn"":true,""rst"":true,""psh"":true,""ack"":true},""netflow"":{""pkts"":8,""bytes"":377,""start"":""2023-08-24T10:46:02.404611+0000"",""end"":""2023-08-24T10:46:21.574411+0000"",""age"":19,""min_ttl"":116,""max_ttl"":248},""event_type"":""netflow"",""flow_id"":135923717778563,""dest_ip"":""10.0.11.115"",""proto"":""TCP"",""dest_port"":22,""timestamp"":""2023-08-24T10:50:10.500130+0000""}}"
2023-08-24 10:49:34.000,"{""firewall_name"":""firewall"",""availability_zone"":""ap-southeast-3a"",""event_timestamp"":""1692874174"",""event"":{""src_ip"":""180.252.123.23"",""src_port"":44331,""tcp"":{""tcp_flags"":""16"",""syn"":true,""rst"":true,""ack"":true},""netflow"":{""pkts"":4,""bytes"":172,""start"":""2023-08-24T10:48:18.381983+0000"",""end"":""2023-08-24T10:48:22.573601+0000"",""age"":4,""min_ttl"":116,""max_ttl"":248},""event_type"":""netflow"",""flow_id"":536380034962463,""dest_ip"":""10.0.11.115"",""proto"":""TCP"",""dest_port"":22,""timestamp"":""2023-08-24T10:49:34.559055+0000""}}"
2023-08-24 10:48:18.000,"{""firewall_name"":""firewall"",""availability_zone"":""ap-southeast-3a"",""event_timestamp"":""1692874098"",""event"":{""src_ip"":""180.252.123.23"",""src_port"":44331,""event_type"":""alert"",""alert"":{""severity"":3,""signature_id"":1,""rev"":0,""signature"":"""",""action"":""allowed"",""category"":""""},""flow_id"":536380034962463,""dest_ip"":""10.0.11.115"",""proto"":""TCP"",""dest_port"":22,""timestamp"":""2023-08-24T10:48:18.381983+0000""}}"
2023-08-24 10:46:02.000,"{""firewall_name"":""firewall"",""availability_zone"":""ap-southeast-3a"",""event_timestamp"":""1692873962"",""event"":{""src_ip"":""180.252.123.23"",""src_port"":44293,""event_type"":""alert"",""alert"":{""severity"":3,""signature_id"":1,""rev"":0,""signature"":"""",""action"":""allowed"",""category"":""""},""flow_id"":135923717778563,""dest_ip"":""10.0.11.115"",""proto"":""TCP"",""dest_port"":22,""timestamp"":""2023-08-24T10:46:02.404611+0000""}}"
```