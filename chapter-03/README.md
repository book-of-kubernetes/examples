# Resource Limiting

This folder provides the examples for the chapter "Resource Limiting".

## Prerequisites

Be sure to start by following the instructions in the `setup` folder.

## Ubuntu 24.04 and Kubernetes 1.34 Notes

Ubuntu 24.04 uses cgroup v2 only, which has a single unified hierarchy
rather than a separate directory per controller. Where the book uses a path
such as `/sys/fs/cgroup/cpu/pod.slice/...`, drop the `cpu/` or `memory/`
part (e.g. `/sys/fs/cgroup/pod.slice/...`). The cgroup v1 files map to
cgroup v2 like this:

* `cpu.shares` becomes `cpu.weight`
* `cpu.cfs_quota_us` and `cpu.cfs_period_us` are combined into `cpu.max`
  (e.g. `10000 100000`, or `max 100000` for no limit)
* `memory.limit_in_bytes` becomes `memory.max`

To find the cgroup for a container, use:

```
find /sys/fs/cgroup -name "crio-<container id>*.scope"
```

For example, to manually limit a container to half a CPU, write
`echo '50000 100000' > cpu.max` in its cgroup directory.

## Running in AWS

Start by provisioning:

```
ansible-playbook aws-setup.yaml
```

Then, run the main playbook:

```
ansible-playbook playbook.yaml
```

For this chapter, we create two virtual machines, `host01` and `host02`.
However, `host02` is just a small virtual machine that runs an `iperf3`
server for network testing, so all of our interaction will be with `host01`.

You can SSH to `host01` and become root by running:

```
./aws-ssh.sh host01
sudo su -
```

When finished, don't forget to clean up:

```
ansible-playbook aws-teardown.yaml
```

## Running in Vagrant

To start:

```
vagrant up
```

This will also run the main Ansible playbook.

For this chapter, we create two virtual machines, `host01` and `host02`.
However, `host02` is just a small virtual machine that runs an `iperf3`
server for network testing, so all of our interaction will be with `host01`.

You can SSH to `host01` and become root by running:

```
vagrant ssh host01
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
