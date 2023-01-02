# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'containerd busybox' {
  run -0 ctr image pull docker.io/library/busybox:latest
  run -0 ctr images ls
  assert_output --partial docker.io/library/busybox:latest
  run -0 ctr run --rm docker.io/library/busybox:latest v1 /bin/sh -c \
    'ip a; ps'
  assert_output --partial 'inet'
  assert_output --partial 'PID'
}
