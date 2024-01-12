# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'nginx containers' {
  run -0 /bin/bash -ec '\
    cd /opt
    source nginx.sh
    crictl ps
    crictl exec $N1C_ID cat /proc/net/tcp
    crictl exec $N2C_ID cat /proc/net/tcp'
  assert_output --partial 'nginx1'
  assert_output --partial 'nginx2'
  assert_output --partial '0050'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
