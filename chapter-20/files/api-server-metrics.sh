#!/bin/bash
conf=/etc/kubernetes/admin.conf
cert=/etc/kubernetes/pki/admin.crt
key=/etc/kubernetes/pki/admin.key
ca=/etc/kubernetes/pki/ca.crt

grep client-key-data $conf | cut -d" " -f 6 | base64 -d > $key
grep client-cert $conf | cut -d" " -f 6 | base64 -d > $cert

curl --cacert $ca --cert $cert --key $key https://192.168.61.10:6443/metrics
echo ""
