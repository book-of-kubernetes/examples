# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'crio container manually limited' {
  run -0 crictl pull docker.io/bookofkubernetes/stress:stable
  PUL_ID=$(crictl runp /opt/po-nolim.yaml)
  CUL_ID=$(crictl create $PUL_ID /opt/co-nolim.yaml /opt/po-nolim.yaml)
  run -0 crictl start $CUL_ID
  run -0 crictl ps
  assert_output --partial stress
  assert_output --partial Running
  STRESS_PIDS=$(pgrep -d , stress)
  run -0 top -b -n 1 -p "${STRESS_PIDS}"
  assert_output --partial 'stress'
  run -0 renice -n 19 -p $(pgrep -d ' ' stress)
  run -0 /bin/sh -ec "\
    cd /sys/fs/cgroup/cpu/system.slice/runc-${CUL_ID}.scope
    cat cgroup.procs
    cat cpu.cfs_quota_us
    echo '50000' > cpu.cfs_quota_us"
  assert_output --partial '-1'
  run -0 top -b -n 1 -p "${STRESS_PIDS}"
  assert_output --partial 'stress'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
