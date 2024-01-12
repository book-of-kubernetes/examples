# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'busybox container' {
  run -0 /bin/bash -ec '\
    cd /opt
    source busybox.sh
    crictl ps
    crictl exec $B1C_ID /bin/sh -c "ip addr"
    crictl exec $B1C_ID /bin/sh -c "ping -c 1 192.168.61.11"
    crictl exec $B1C_ID /bin/sh -c "ip route"
    JQ_PATH=".info.runtimeSpec.linux.namespaces[]|select(.type==\"network\").path"
    NETNS_PATH=$(crictl inspectp $B1P_ID | jq -r $JQ_PATH)
    echo $NETNS_PATH
    NETNS=$(basename $NETNS_PATH)
    ip netns exec $NETNS ip addr'
  assert_output --partial 'busybox'
  assert_output --partial 'inet 10.85.0'
  assert_output --partial '64 bytes from 192.168.61.11'
  assert_output --partial 'default via 10.85.0.1'
  assert_output --partial '/var/run/netns'
  run -0 lsns -t net
  assert_output --partial '/pause'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
