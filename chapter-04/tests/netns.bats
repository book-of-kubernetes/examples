# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'create and manipulate a network namespace' {
  ip netns add myns
  run -0 ip netns list
  assert_output --partial 'myns'
  run -0 ip netns exec myns ip addr
  assert_output --partial 'DOWN'
  ip netns exec myns ip link set dev lo up
  run -0 ip netns exec myns ip addr
  assert_output --partial 'UP'
  ip link add myveth-host type veth peer myveth-myns netns myns
  run -0 ip addr
  assert_output --partial 'myveth-host'
  run -0 ip netns exec myns ip addr
  assert_output --partial 'myveth-myns'
  ip netns exec myns ip addr add 10.85.0.254/16 dev myveth-myns
  ip netns exec myns ip link set dev myveth-myns up
  ip link set dev myveth-host up
  run -0 ip netns exec myns ip addr
  assert_output --partial '10.85.0.254'
  run -0 ip netns exec myns ping -c 1 10.85.0.254
  assert_output --partial '64 bytes from 10.85.0.254'
  run -1 ping -c 1 10.85.0.254
  assert_output --partial 'Destination Host Unreachable'
  brctl addif cni0 myveth-host
  run -0 brctl show
  assert_output --partial 'myveth-host'
  run -0 ping -c 1 10.85.0.254
  assert_output --partial '64 bytes from 10.85.0.254'
  run -2 ip netns exec myns ping -c 1 192.168.61.11
  assert_output --partial 'Network is unreachable'
  ip netns exec myns ip route add default via 10.85.0.1
  run -0 ip netns exec myns ping -c 1 192.168.61.11
  assert_output --partial '64 bytes from 192.168.61.11'
  run -1 ip netns exec myns ping -c 1 192.168.61.12
  assert_output --partial '0 received'
  iptables -t nat -N chain-myns
  iptables -t nat -A chain-myns -d 10.85.0.0/16 -j ACCEPT
  iptables -t nat -A chain-myns ! -d 224.0.0.0/4 -j MASQUERADE
  iptables -t nat -A POSTROUTING -s 10.85.0.254 -j chain-myns
  run -0 iptables -t nat -n -L
  assert_output --partial 'chain-myns'
  run -0 ip netns exec myns ping -c 1 192.168.61.12
  assert_output --partial '64 bytes from 192.168.61.12'
}

teardown() {
  ip -all netns delete
  iptables -t nat -D POSTROUTING -s 10.85.0.254 -j chain-myns
  iptables -t nat -F chain-myns
  iptables -t nat -X chain-myns
}