# bats file_tags=host01

setup() {
  BATS_LIB_PATH=/usr/local/lib/node_modules
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_require_minimum_version 1.5.0
}

@test 'crio container cpu limited' {
  run -0 crictl pull docker.io/bookofkubernetes/stress:stable
  PCL_ID=$(crictl runp /opt/po-clim.yaml)
  CCL_ID=$(crictl create $PCL_ID /opt/co-clim.yaml /opt/po-clim.yaml)
  run -0 crictl start $CCL_ID
  run -0 crictl ps
  assert_output --partial stress
  assert_output --partial Running
  run -0 /bin/sh -ec "\
    cd /sys/fs/cgroup/cpu/pod.slice/crio-${CCL_ID}.scope
    cat cpu.cfs_quota_us"
  assert_output --partial '10000'
}

teardown() {
  crictl rm -a -f
  crictl rmp -a -f
}
