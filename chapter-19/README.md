# Tuning Quality of Service

This folder provides the examples for the chapter "Tuning Quality of Service".

## Prerequisites

Be sure to start by following the instructions in the `setup` folder.

## Ubuntu 24.04 and Kubernetes 1.34 Notes

Ubuntu 24.04 uses cgroup v2 only, so the `cgroup-info` script reports
`CPU Weight` (from `cpu.weight`) instead of `CPU Shares`, reads the CPU quota
from `cpu.max`, and reads the memory limit from `memory.max`. A pod with no
limit shows `max` rather than `-1` or a very large number. With cgroup v2,
all controllers share one hierarchy under `/sys/fs/cgroup`.

## Running in AWS

Start by provisioning:

```
ansible-playbook aws-setup.yaml
```

Then, run the main playbook:

```
ansible-playbook playbook.yaml
```

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

You can SSH to `host01` and become root by running:

```
vagrant ssh host01
sudo su -
```

When finished, you can clean up the VM:

```
vagrant destroy
```
