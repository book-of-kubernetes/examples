# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'build docker image' {
  run -0 /bin/bash -c '\
    cd /opt/hello
    docker build -t hello .'
  run -0 docker images
  assert_output --partial 'hello'
  docker run --name hello -d -p 8080:80 hello
  retry -d 1 -t 30 -- curl http://localhost:8080/
  run -0 curl http://localhost:8080/
  assert_output --partial 'Hello World!'
}

teardown() {
  docker rm --force hello
  docker rmi --force hello
}
