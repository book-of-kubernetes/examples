# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'crio container' {
  run -0 crictl pull docker.io/library/busybox:latest
  POD_ID=$(crictl runp /opt/pod.yaml)
  CONTAINER_ID=$(crictl create $POD_ID /opt/container.yaml /opt/pod.yaml)
  run -0 crictl start $CONTAINER_ID
  run -0 crictl ps
  assert_output --partial Running
  run -0 crictl exec $CONTAINER_ID /bin/sh -c \
    'ip a; ps'
  assert_output --partial 'inet'
  assert_output --partial 'PID'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
