# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'crio container memory limited' {
  run -0 crictl pull docker.io/bookofkubernetes/stress:stable
  PML_ID=$(crictl runp /opt/po-mlim.yaml)
  CML_ID=$(crictl create $PML_ID /opt/co-mlim.yaml /opt/po-mlim.yaml)
  run -0 crictl start $CML_ID
  run -0 crictl ps
  assert_output --partial stress
  assert_output --partial Running
  retry -d 1 -t 30 -- /bin/bash -c "crictl logs $CML_ID |& grep -q OOM"
  run -0 crictl logs $CML_ID
  assert_output --partial 'SIGKILL'
  assert_output --partial 'OOM killer'
  run -0 dmesg
  assert_output --partial 'oom_reaper'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
