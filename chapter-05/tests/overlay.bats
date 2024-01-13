# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'overlay filesystem' {
  mkdir /tmp/{lower,upper,work,mount}
  echo "hello1" > /tmp/lower/hello1
  echo "hello2" > /tmp/upper/hello2
  mount -t overlay -o rw,lowerdir=/tmp/lower,upperdir=/tmp/upper,workdir=/tmp/work overlay /tmp/mount
  run -0 cat /tmp/mount/hello1
  assert_output --partial 'hello1'
  run -0 cat /tmp/mount/hello2
  assert_output --partial 'hello2'
  echo "hello3" > /tmp/mount/hello3
  run -0 ls /tmp/lower
  refute_output --partial 'hello3'
  run -0 ls /tmp/upper
  assert_output --partial 'hello3'
}

teardown() {
  umount -f /tmp/mount
  rm -fr /tmp/{lower,upper,work,mount}    
}
