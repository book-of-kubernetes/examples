# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'nginx' {
  docker pull nginx
  run -0 docker images
  assert_output --partial 'nginx'
  docker run --name nginx -d nginx
  run -0 docker exec nginx /bin/sh -c 'ldd $(which nginx)'
  assert_output --partial 'libc'
  JQ_QUERY='.[0].SizeRw'
  run -0 /bin/bash -c "docker inspect -s nginx | jq ${JQ_QUERY}"
  assert_output --regexp '^[0-9]+$'
  JQ_QUERY='.[0].GraphDriver.Data.MergedDir'
  ROOT=$(docker inspect nginx | jq -r "${JQ_QUERY}")
  ls ${ROOT}
  run -0 mount
  assert_output --partial 'merged'
}

teardown() {
  docker rm --force nginx
}
