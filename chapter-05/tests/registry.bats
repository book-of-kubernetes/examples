# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'local registry' {
  docker pull busybox
  docker tag busybox registry.local/busybox
  docker push registry.local/busybox
  docker pull registry.local/busybox
}

teardown() {
  docker rmi --force busybox
  docker rmi --force registry.local/busybox
}
