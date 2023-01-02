# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'run nginx' {
  run -0 docker run -d -p 8080:80 --name nginx nginx
  run -0 docker ps
  assert_output --partial nginx
  run -0 curl http://localhost:8080
  assert_output --partial 'Welcome to nginx!'
  run -0 ps -ef
  assert_output --partial 'nginx'
}

teardown() {
  docker rm -f nginx    
}