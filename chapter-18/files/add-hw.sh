#!/bin/bash
conf=/etc/kubernetes/admin.conf
cert=/etc/kubernetes/pki/admin.crt
key=/etc/kubernetes/pki/admin.key
ca=/etc/kubernetes/pki/ca.crt

grep client-key-data $conf | cut -d" " -f 6 | base64 -d > $key
grep client-cert $conf | cut -d" " -f 6 | base64 -d > $cert

patch='
[
  {
    "op": "add", 
    "path": "/status/capacity/bookofkubernetes.com~1special-hw", 
    "value": "3"
  }
]
'

curl --cacert $ca --cert $cert --key $key \
  -H "Content-Type: application/json-patch+json" \
  -X PATCH -d "$patch" \
  https://192.168.61.10:6443/api/v1/nodes/host02/status
echo ""
