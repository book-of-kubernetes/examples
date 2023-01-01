
setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'run kubectl' {
  run -0 k3s kubectl version
  assert_output --partial 'Server Version'
  run -0 k3s kubectl get nodes
  assert_output --partial host01
}

@test 'check todo' {
  run -0 k3s kubectl get pods
  assert_output --partial todo-db
  run -0 k3s kubectl describe svc todo
  assert_output --partial todo
}