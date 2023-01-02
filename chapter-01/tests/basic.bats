# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'docker run rocky' {
  run -0 docker run --rm rockylinux:8 /bin/sh -c \
    'cat /etc/os-release; yum install -y procps iproute; ps -ef; ip addr; uname -v'
  assert_output --partial 'Rocky Linux' 
  assert_output --partial 'UID'
  assert_output --partial 'inet'
  assert_output --partial 'Ubuntu'
}

@test 'docker run alpine' {
  run -0 docker pull alpine:3
  run -0 docker run --rm -v /:/host -e hello=world alpine:3 /bin/sh -c \
    'cat /etc/os-release; cat /host/etc/os-release; echo $hello'
  assert_output --partial 'Alpine'
  assert_output --partial 'Ubuntu'
  assert_output --partial 'world'
}
